import 'package:flutter/material.dart';
import 'channel_list_screen.dart';

void main() {
  runApp(const MyIPTVApp());
}

class MyIPTVApp extends StatelessWidget {
  const MyIPTVApp({super.key}); // Cambiado a super.key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicación IPTV',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.blueAccent,
          secondary: Colors.cyanAccent,
        ),
      ),
      home: const ChannelListScreen(),
    );
  }
}