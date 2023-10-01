import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:fiboutiquesv1/widgets/home_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../Providers/audio_rec_play_provider.dart';
import '../Providers/database_provider.dart';
import '../Providers/home_screen_provider.dart';
class MyHomeScree extends StatefulWidget {
  const MyHomeScree({super.key});

  @override
  State<MyHomeScree> createState() => _MyHomeScreeState();
}

class _MyHomeScreeState extends State<MyHomeScree> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 1), () {
      Provider.of<AudioProvider>(context, listen: false)
          .initialiseControllers();
      Provider.of<AudioProvider>(context, listen: false).getDir();
      Provider.of<DatabaseProvider>(context, listen: false).getData();
      Provider.of<HomeScreenProvider>(context, listen: false)
          .addAllToFiltered();
      Provider.of<AudioProvider>(context, listen: false).initPlayer();
    });
    // TODO: implement initState
    super.initState();
  }

  Color mcolor = const Color(0xff368983);

  @override
  void dispose() {
    Provider.of<AudioProvider>(context, listen: false)
        .recorderController
        .dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: Consumer<AudioProvider>(
        builder: (context, audioProvider, child) => Container(
          width: audioProvider.isRecording ? 320.w : 70.w,
          height: 80.h,
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.r),
              color: Colors.white,
              border: Border.all(color: mcolor),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 10.r, spreadRadius: 2.r),
              ]),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
              onPressed: () {
                audioProvider.startOrStopRecording(context);
              },
              icon: Icon(audioProvider.isRecording ? Icons.stop : Icons.mic),
              color: mcolor,
              iconSize: 35.sp,
            ),
            Visibility(
                visible: audioProvider.isRecording,
                child: AudioWaveforms(
                  size: Size(250.w, 50.h),
                  recorderController: audioProvider.recorderController,
                  waveStyle: WaveStyle(
                    waveColor: mcolor,
                    extendWaveform: true,
                    showMiddleLine: false,
                  ),
                ),
                ),
            // AnimatedSwitcher(
            //   duration: const Duration(milliseconds: 1000),
            //   switchInCurve: Curves.bounceOut,
            //   layoutBuilder: (currentChild, previousChildren) =>
            //       audioProvider.isRecording
            //           ? AudioWaveforms(
            //               size: Size(250.w, 50.h),
            //               recorderController: audioProvider.recorderController,
            //               waveStyle: WaveStyle(
            //                 waveColor: Colors.green.shade600,
            //                 extendWaveform: true,
            //                 showMiddleLine: false,
            //               ),
            //             )
            //           : Text(
            //               "Please try again",
            //               style: TextStyle(
            //                 color: Colors.green.shade600,
            //                 fontSize: 20.sp,
            //                 fontWeight: FontWeight.w400,
            //               ),
            //             ),
            // ),
          ]),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const HomeAppBar(),
                const SizedBox(
                  height: 10,
                ),

                ///listviw audio

                Consumer<AudioProvider>(
                  builder: (context, audioProvider, child) => Visibility(
                    visible: audioProvider.fileList.isNotEmpty,
                    child: Container(
                      color: Colors.grey.withOpacity(0.1),
                      height: 100.h,
                      // padding: EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: audioProvider.fileList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          String fileName0 = audioProvider.fileList[index].path
                              .replaceAll(
                                  "/data/user/0/com.example.fiboutiquesv1/app_flutter/",
                                  "");
                          String fileName1 = fileName0.replaceAll(".m4a", "");
                          return Container(
                            // padding: EdgeInsets.symmetric(vertical: 1.h),
                            margin: EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 4.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(color: mcolor, width: 2.w)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    audioProvider.isPlaying
                                        ? audioProvider.stopPlayer()
                                        : audioProvider.preparePlayer(
                                            audioProvider.fileList[index].path,
                                            index);
                                  },
                                  icon: CircleAvatar(
                                      backgroundColor: mcolor,
                                      radius: 18.r,
                                      child: Icon(
                                        audioProvider.isPlaying
                                            ? audioProvider.selectedIndex ==
                                                    index
                                                ? CupertinoIcons.pause
                                                : CupertinoIcons
                                                    .play_arrow_solid
                                            : CupertinoIcons.play_arrow_solid,
                                        color: Colors.white,
                                        size: 15.sp,
                                      )),
                                ),
                                SizedBox(width: 10.w),
                                audioProvider.isPlaying
                                    ? audioProvider.selectedIndex == index
                                        ? AudioFileWaveforms(
                                            size: Size(250.w, 45.h),
                                            playerController:
                                                audioProvider.playerController,
                                            enableSeekGesture: true,
                                            continuousWaveform: true,
                                            animationCurve: Curves.decelerate,
                                            animationDuration:
                                                const Duration(seconds: 1),
                                            waveformType: WaveformType.long,
                                            playerWaveStyle: PlayerWaveStyle(
                                              fixedWaveColor: mcolor,
                                              liveWaveColor: mcolor,
                                              spacing: 4.w,
                                            ),
                                          )
                                        : Text(
                                            fileName1,
                                            style: TextStyle(
                                              color: mcolor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                    : Text(
                                        fileName1,
                                        style: TextStyle(
                                          color: mcolor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                SizedBox(width: 10.w),
                                IconButton(
                                    onPressed: () {
                                      Fluttertoast.showToast(msg: "Audio supprimmer avec succes");
                                      audioProvider.deleteAudio(index);
                                    },
                                    icon: CircleAvatar(
                                        backgroundColor: mcolor,
                                        radius: 15.r,
                                        child: Icon(
                                          Icons.close,
                                          size: 20.sp,
                                          color: Colors.white,
                                        )))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<DatabaseProvider>(
                          builder: (context, databaseProvider, child) => databaseProvider.selectedIndex == -1 ? Container() : IconButton(
                            onPressed: () {
                              databaseProvider.saveOrder();
                            },
                            icon: Icon(
                              Icons.shopping_cart,
                              color: mcolor,
                              size: 25,
                              shadows: const [
                                BoxShadow(
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Consumer<DatabaseProvider>(
                          builder: (context, databaseProvider, child) => IconButton(
                              icon: Icon(
                                Icons.add,
                                color: mcolor,
                                size: 25,
                                shadows: const [
                                  BoxShadow(
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                databaseProvider.addProductDialog(context, mcolor);
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                //
                SizedBox(
                  width: 400,
                  // padding: EdgeInsets.all(12),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Consumer<DatabaseProvider>(
                          builder: (context, databaseProvider, child) => Visibility(
                              visible: databaseProvider.selectedIndex != -1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(databaseProvider.selectedIndex == -1 ? "not selected" : databaseProvider.selectedText.text),
                                  Flexible(
                                    child: SizedBox(
                                      width: 80,
                                      height: 35, // Add this line
                                      child: TextField(
                                        controller: databaseProvider.productSellingPriceController1,
                                        decoration: InputDecoration(
                                          labelText: 'selling price',
                                          labelStyle: TextStyle(
                                              fontSize: 10.sp, color: Colors.grey.shade500),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                            borderSide: BorderSide(
                                                width: 2.w, color: Color(0xffC5C5C5)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                width: 2, color: Color(0xff368983)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: SizedBox(
                                      width: 80,
                                      height: 35,
                                      // Add this line
                                      child: TextField(
                                        controller: databaseProvider.productBuyingPriceController1,
                                        decoration: InputDecoration(
                                          labelText: 'Buying Price',
                                          labelStyle: TextStyle(
                                              fontSize: 10.sp, color: Colors.grey.shade500),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                width: 2, color: Color(0xffC5C5C5)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                width: 2, color: Color(0xff368983)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: SizedBox(
                                      width: 80,
                                      height: 35,
                                      // Add this line
                                      child: TextField(
                                        controller: databaseProvider.productQuantityController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          labelText: 'Quantity',
                                          labelStyle: TextStyle(
                                              fontSize: 10.sp, color: Colors.grey.shade500),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                width: 2, color: Color(0xffC5C5C5)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                width: 2, color: Color(0xff368983)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              databaseProvider.deleteData();
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              ),
                              ),
                    ],
                  ),
                ),
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Consumer<AudioProvider>(
            //     builder: (context, audioProvider, child) => Container(
            //       width: audioProvider.isRecording ? 320.w : 70.w,
            //       height: 80.h,
            //       alignment: Alignment.center,
            //       padding: EdgeInsets.zero,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(40.r),
            //           color: Colors.white,
            //           border: Border.all(color: mcolor),
            //           boxShadow: [
            //             BoxShadow(
            //                 color: Colors.black12, blurRadius: 10.r, spreadRadius: 2.r),
            //           ]),
            //       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //         IconButton(
            //           onPressed: () {
            //             audioProvider.startOrStopRecording(context);
            //           },
            //           icon: Icon(audioProvider.isRecording ? Icons.stop : Icons.mic),
            //           color: mcolor,
            //           iconSize: 35.sp,
            //         ),
            //         Visibility(
            //             visible: audioProvider.isRecording,
            //             child: AudioWaveforms(
            //               size: Size(250.w, 50.h),
            //               recorderController: audioProvider.recorderController,
            //               waveStyle: WaveStyle(
            //                 waveColor: mcolor,
            //                 extendWaveform: true,
            //                 showMiddleLine: false,
            //               ),
            //             ))
            //         // AnimatedSwitcher(
            //         //   duration: const Duration(milliseconds: 1000),
            //         //   switchInCurve: Curves.bounceOut,
            //         //   layoutBuilder: (currentChild, previousChildren) =>
            //         //       audioProvider.isRecording
            //         //           ? AudioWaveforms(
            //         //               size: Size(250.w, 50.h),
            //         //               recorderController: audioProvider.recorderController,
            //         //               waveStyle: WaveStyle(
            //         //                 waveColor: Colors.green.shade600,
            //         //                 extendWaveform: true,
            //         //                 showMiddleLine: false,
            //         //               ),
            //         //             )
            //         //           : Text(
            //         //               "Please try again",
            //         //               style: TextStyle(
            //         //                 color: Colors.green.shade600,
            //         //                 fontSize: 20.sp,
            //         //                 fontWeight: FontWeight.w400,
            //         //               ),
            //         //             ),
            //         // ),
            //       ]),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  //
  // Widget buildProduct(BuildContext context) => ;

  //

  // Widget getList(String history, int index) {
  //   return Dismissible(
  //       key: UniqueKey(),
  //       onDismissed: (direction) {
  //         //  history.delete();
  //       },
  //       child: get(index, history));
  // }
  //
  // ListTile get(int index, String history) {
  //   return ListTile(
  //     leading: ClipRRect(
  //       borderRadius: BorderRadius.circular(5),
  //       //child: Image.asset('images/${history.name}.png', height: 40),
  //     ),
  //     title: const Text(
  //       // history.name,
  //       'historyname',
  //       style: TextStyle(
  //         fontSize: 17,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //     subtitle: const Text(
  //       'historydate',
  //       style: TextStyle(
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //     trailing: const Text(
  //       // history.amount,
  //       'Total price',
  //       style: TextStyle(
  //         fontWeight: FontWeight.w600,
  //         fontSize: 19,
  //       ),
  //     ),
  //   );
  // }
}
