import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'video_player_screen.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({super.key}); // Cambiado a super.key

  @override
  ChannelListScreenState createState() => ChannelListScreenState();
}

class ChannelListScreenState extends State<ChannelListScreen> {
  List<Map<String, String>> channels = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadM3UChannels("https://raw.githubusercontent.com/Free-TV/IPTV/master/playlist.m3u8");
  }

  Future<void> loadM3UChannels(String url) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            channels = parseM3U(response.body);
          });
        }
      } else {
        _showErrorSnackBar('Error al cargar el archivo M3U: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Error de red: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  List<Map<String, String>> parseM3U(String content) {
    final List<Map<String, String>> channelList = [];
    final lines = content.split('\n');
    Map<String, String>? channel;

    for (var line in lines) {
      if (line.startsWith('#EXTINF')) {
        final name = line.split(',').length > 1 ? line.split(',')[1].trim() : 'Canal sin nombre';
        channel = {'name': name};
      } else if (line.startsWith('http') && channel != null) {
        channel['url'] = line.trim();
        channelList.add(channel);
        channel = null; // Reset channel after adding
      }
    }
    return channelList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canales IPTV')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : channels.isEmpty
              ? Center(
                  child: ElevatedButton(
                    onPressed: () => loadM3UChannels("https://raw.githubusercontent.com/Free-TV/IPTV/master/playlist.m3u8"),
                    child: const Text("Cargar Canales"),
                  ),
                )
              : ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    return ListTile(
                      title: Text(channel['name'] ?? 'Canal sin nombre'),
                      onTap: () {
                        final url = channel['url'];
                        if (url != null && url.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(url: url),
                            ),
                          );
                        } else {
                          _showErrorSnackBar('URL del canal no válida');
                        }
                      },
                    );
                  },
                ),
    );
  }
}