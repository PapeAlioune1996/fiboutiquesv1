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

  void startOrStopRecording(BuildContext context) async { 
    stopPlayer();
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

  preparePlayer(String path, int index) async {
    selectedIndex = index;
    String encodedFilePath = Uri.encodeFull(path); // Encode special characters
    Uri fileUri =
    Uri.parse("file://$encodedFilePath"); // Create URL with encoded path
    String fileUrl = fileUri.toString(); // This will give you a valid file URL
   // print("path ================== $fileUrl");
    await playerController.preparePlayer(
      path: fileUrl,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1,
    );
    await playerController.startPlayer(finishMode: FinishMode.stop);
    notifyListeners();
  }

  initPlayer() {
    playerController = PlayerController()
      ..onPlayerStateChanged.listen((state) {
        // print("$state state''''''''''''''''''''''''.............");
        isPlaying = state.isPlaying;
        notifyListeners();
      }) // Listening to player state changes
      ..onCurrentDurationChanged.listen((duration) {
        // print("$duration durationnnnnnnnnnnnnnnnnnnnnnnnnn");
      }) // Listening to current duration changes
      ..onCurrentExtractedWaveformData.listen((data) {
        // print("$data dataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      }) // Listening to latest extraction data
      ..onExtractionProgress.listen((progress) {
        // print("$progress progressssssssssssssssssssssssssssssss");
      })
      ..onCompletion.listen((_) {
        stopPlayer();
        // print("stopped==========================>>>>>>>>>>>>>>>>>>");
      })
      ..setVolume(1.0)
      ..setRefresh(true)
      ..shouldRefresh;
    notifyListeners();
  }

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
