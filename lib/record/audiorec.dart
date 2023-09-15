import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioRecordCard extends StatelessWidget {
  final String title;
  final String path;

  AudioRecordCard({required this.title, required this.path});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(title),
          ),
          IconButton(
            icon: Icon(Icons.play_circle_filled),
            onPressed: () {
              // Add code to play the audio using audioplayers or your chosen audio player package.
              // Example: AudioPlayer().play(path);
            },
          ),
        ],
      ),
    );
  }
}
