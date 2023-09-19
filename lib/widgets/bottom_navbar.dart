
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:fiboutiquesv1/screen/home.dart';
import 'package:fiboutiquesv1/screen/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';



class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  set _fabHeight(double _fabHeight) {}

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  List Screen = [MyHomeScree(),  Statistics()];

  late final RecorderController recorderController;

  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
    isLoading = false;
    setState(() {});
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

   @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

    void onstartRecording() async {
    try {
     
        recorderController.reset();

        final path = await recorderController.stop(false);

        if (path != null) {
          isRecordingCompleted = true;
          debugPrint(path);
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }
      
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }
  void onstopRecording() async {
    try {
      
        await recorderController.record(path: path!);
      
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }


 
 

  @override
  Widget build(BuildContext context) {
late double _fabHeight = 56.0;
    return Scaffold(
      body: Screen[index_color],
      floatingActionButton: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _fabHeight,
        child : FloatingActionButton( 
      autofocus: true,
        clipBehavior: Clip.none,
        shape: CircleBorder(eccentricity: 0.1),
        onPressed: ()  {
           if (isRecording) {
            onstopRecording();
          } else {
            onstartRecording();
          }
        },
        child: isRecording ? Icon(
          Icons.stop_circle_outlined,
          color: Colors.white,
          ) : Icon(Icons.mic_none_outlined,
            color: Colors.white,
          ),
        
        backgroundColor: Color(0xff368983),
        
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 55,
        shape: CircularNotchedRectangle(),
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
                  color: index_color == 0 ? Color(0xff368983) : Colors.grey,
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
                  color: index_color == 1 ? Color(0xff368983) : Colors.grey,
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