import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class AudioProvider extends ChangeNotifier {
  late RecorderController recorderController;
   late PlayerController playerController;
  TextEditingController renameController = TextEditingController();
  TextEditingController renameController0 = TextEditingController();

  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isPlaying = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;
  late List<FileSystemEntity> files;

  late List<FileSystemEntity> fileList;

  Map<String, double> playbackPositions = {};

  late List fileList1;

  late DateTime time;
  int selectedIndex = -1;
  //initialise
    AudioProvider() {
    recorderController = RecorderController();
    fileList = []; 
   time = DateTime.now();
  }

  void getTimeNow() {
    Timer.periodic(const Duration(milliseconds: 1), (timer) async {
      recorderController.refresh();
      time = DateTime.now();
      
      notifyListeners();
    });
  }

  void getDir() async {
    getTimeNow();
    appDirectory = await getApplicationDocumentsDirectory();
    files = appDirectory.listSync();
    notifyListeners();
    fileList = files.where((element) => element.path.endsWith("m4a")).toList();
    notifyListeners();
    path = "${appDirectory.path}/New Audio ${time.day}${time.millisecond}${time.second}.m4a";
   // print(path);
    isLoading = false;
    notifyListeners();
  }

  void initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..shouldRefresh
      ..updateFrequency
      ..refresh()
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
    notifyListeners();
    // ignore: avoid_print
    print("initiazed................========>>>>>>>>>");
  }

  void stopAllAudioPlayback() {
   //AudioService.stop();
    stopPlayer(); // You can call your existing stopPlayer method here as well
  }

  void startOrStopRecording(BuildContext context) async { 
    
    if (isPlaying) {
    stopPlayer(); // Stop the player if it's currently playing
  }
    try {
      if (isRecording) {
        recorderController.reset();
        
        final path = await recorderController.stop(false);
        getDir();
        if (path != null) {
          isRecordingCompleted = true;
          debugPrint(path);
          notifyListeners();
          Fluttertoast.showToast(msg: "Audio ajouter avec success");
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }else{
          // ignore: use_build_context_synchronously
          showDialog(context: context,
            barrierDismissible: false,builder: (context) {
             
            Timer(const Duration(seconds: 1), () {
              Navigator.pop(context);
            });
            return AlertDialog(
            title: Text(
              "Please try again",
              style: TextStyle(
                color: Colors.green.shade600,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
            },);
        }
      } else {
        await recorderController.record(path: path!);
        recorderController.refresh();
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isRecording = !isRecording;
      notifyListeners();
    }
  }

  void refreshWave() {
    if (isRecording) recorderController.refresh();
  }


 Future<void> mypreparePlayer(String path, int index) async {
  
    selectedIndex = index;
    String encodedFilePath = Uri.encodeFull(path);
    Uri fileUri = Uri.parse("file://$encodedFilePath");
    String fileUrl = fileUri.toString();
    bool ispaused = false;
    try{
    await playerController.preparePlayer(
      path: fileUrl,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 2,
    );

    await playerController.startPlayer(finishMode: FinishMode.pause);
    isPlaying = true;
    notifyListeners();
  } catch (e) {
    debugPrint('Error during playback: $e');
    // Handle the error as needed (e.g., show an error message to the user).
  }
}


 ///////////////////////////
double _currentPlaybackPosition = 0.0;
  double get currentPlaybackPosition => _currentPlaybackPosition;

  double _extractionProgress = 0.0;
  double get extractionProgress => _extractionProgress;

  void updatePlaybackPosition(int position) {
    _currentPlaybackPosition = position.toDouble();
    notifyListeners();
  }

  void updateExtractionProgress(double progress) {
    _extractionProgress = progress;
    notifyListeners();
  }
  /////////////////////
  initPlayer() {
    playerController = PlayerController()
      ..onPlayerStateChanged.listen((state) {
       
        isPlaying = state.isPlaying;
        notifyListeners();
      }) // Listening to player state changes
      ..onCurrentDurationChanged.listen((duration) {
       
        updatePlaybackPosition(duration);
        
       // print('duration  $duration');

      }) // Listening to current duration changes
      ..onCurrentExtractedWaveformData.listen((data) {
        // print("$data dataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      }) // Listening to latest extraction data
      ..onExtractionProgress.listen((progress) {
        // print("$progress progressssssssssssssssssssssssssssssss");
        updateExtractionProgress(progress);
       // print('progress  $progress');
      })
      ..onCompletion.listen((_) {
        isPlaying = false;
        stopPlayer();
        // print("stopped==========================>>>>>>>>>>>>>>>>>>");
      })
      ..setVolume(2.0)
      ..setRefresh(true)
      ..shouldRefresh;
    notifyListeners();
  }
///
 bool isPaused = false ;
  void pausePlayer() {
    if (isPlaying) {
      playerController.pausePlayer();
      Future.delayed(const Duration(milliseconds: 100));
      isPaused = true;
      notifyListeners();
    }
  }
 void toggleAudioPlayback(int index) {
  if (isPlaying && selectedIndex == index) {
    stopPlayer();
  } else {
    mypreparePlayer(fileList[index].path, index);
  }
}

///
   
  stopPlayer() async {
    
    playerController.stopAllPlayers();
    selectedIndex = -1;
    playerController.dispose();
    initPlayer();
    isPlaying = false;
    notifyListeners();
  }
  deleteAudio(int index){
    fileList[index].deleteSync();
    getDir();
    notifyListeners();
  }
}
