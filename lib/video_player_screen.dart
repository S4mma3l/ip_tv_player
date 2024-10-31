import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

// Asegúrate de que la clase VideoPlayerScreen sea pública
class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({super.key, required this.url}); // Uso de super.key

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

// Cambia el nombre de la clase de estado para que no comience con un guion bajo
class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource.network(
      widget.url,
    );

    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        looping: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableFullscreen: true,
          enableMute: true,
          enablePlayPause: true,
        ),
      ),
    )..setupDataSource(dataSource);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reproduciendo")),
      body: Center(
        child: BetterPlayer(
          controller: _controller,
        ),
      ),
    );
  }
}