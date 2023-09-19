
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:fiboutiquesv1/screen/home.dart';
import 'package:fiboutiquesv1/screen/statistics.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';



class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  set _fabHeight(double fabHeight) {}

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  List Screen = [const MyHomeScree(),  const Statistics()];

  //late final RecorderController recorderController;

 AudioPlayer audioPlayer = AudioPlayer();
  bool isRecording = false;
  bool isPlaying = false;
  String currentRecordingPath = '';
  List<String> audioPaths = []; // Create an instance of the Record class

 @override
  void initState() {
    super.initState();
    _checkPermissions();
    _loadAudioFiles();
    
  }

  Future<void> _checkPermissions() async {
    if (!(await Permission.microphone.isGranted)) {
      await Permission.microphone.request();
    }
  }

Future<void> _loadAudioFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = await directory.list().toList();
    setState(() {
      audioPaths = files
          .where((file) => file is File && file.path.endsWith('.wav'))
          .map((file) => file.path)
          .toList();
    });
  }
  
  Future<void> _startRecording() async {
    if (await Record().hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/audio_$timestamp.wav';
      await Record().start(
        path: filePath,
        encoder: AudioEncoder.wav,
      );
      setState(() {
        isRecording = true;
        currentRecordingPath = filePath;
      });
    } else {
      // Handle permission not granted
    }
  }


  Future<void> stopRecording() async {
    await Record().stop();
    setState(() {
      isRecording = false;
    });
  }


    Future<void> _stopRecording() async {
    await Record().stop();
    setState(() {
      isRecording = false;
    });
    _loadAudioFiles();
  }

 


 
 

  @override
  Widget build(BuildContext context) {
late double fabHeight = 56.0;
    return Scaffold(
      body: Screen[index_color],
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: fabHeight,
        child : FloatingActionButton( 
      autofocus: true,
        clipBehavior: Clip.none,
        shape: const CircleBorder(eccentricity: 0.1),
        onPressed: ()  {
           if (isRecording) {
            _stopRecording();
          } else {
            _startRecording();
          }
        },
        
        backgroundColor: const Color(0xff368983),
        child: isRecording ? const Icon(
          Icons.stop_circle_outlined,
          color: Colors.white,
          ) : const Icon(Icons.mic_none_outlined,
            color: Colors.white,
          ),
        
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 55,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(bottom : 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               IconButton(
                  onPressed: (){
                    setState(() {
                    index_color = 0;
                  });
                  },
                 
                 icon : Icon(
                  Icons.home,
                  color: index_color == 0 ? const Color(0xff368983) : Colors.grey,
                ),
                
                ),
                IconButton(
                  onPressed: (){
                    setState(() {
                    index_color = 1;
                  });

                },
                icon : Icon(
                  Icons.bar_chart_outlined,
                  color: index_color == 1 ? const Color(0xff368983) : Colors.grey,
                ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }

  //methode
  


}