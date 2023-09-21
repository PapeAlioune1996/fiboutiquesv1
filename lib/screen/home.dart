import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:fiboutiquesv1/screen/settings.dart';
import 'package:fiboutiquesv1/widgets/search_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'Providers/audio_rec_play_provider.dart';

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
              borderRadius: BorderRadius.circular(35.r),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 10.r, spreadRadius: 5.r),
              ]),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
              onPressed: () {
                audioProvider.startOrStopRecording(context);
              },
              icon: Icon(audioProvider.isRecording ? Icons.stop : Icons.mic),
              color: Colors.green.shade600,
              iconSize: 35.sp,
            ),
            Visibility(
                visible: audioProvider.isRecording,
                child: AudioWaveforms(
                  size: Size(250.w, 50.h),
                  recorderController: audioProvider.recorderController,
                  waveStyle: WaveStyle(
                    waveColor: Colors.green.shade600,
                    extendWaveform: true,
                    showMiddleLine: false,
                  ),
                ))
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70, child: _head()),
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
                            border: Border.all(
                                color: Colors.green.shade600, width: 2.w)),
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
                                  backgroundColor: Colors.green.shade600,
                                  radius: 18.r,
                                  child: Icon(
                                    audioProvider.isPlaying
                                        ? audioProvider.selectedIndex == index
                                            ? CupertinoIcons.pause
                                            : CupertinoIcons.play_arrow_solid
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
                                          fixedWaveColor: Colors.green.shade600,
                                          liveWaveColor: Colors.green.shade600,
                                          spacing: 4.w,
                                        ),
                                      )
                                    : Text(
                                        fileName1,
                                        style: TextStyle(
                                          color: Colors.green.shade600,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                : Text(
                                    fileName1,
                                    style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                            SizedBox(width: 10.w),
                            IconButton(
                                onPressed: () {
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
                    IconButton(
                      onPressed: () {},
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
                    IconButton(
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
                        onPressed: () {}),
                  ],
                ),
              ),
            ),
            //

            Expanded(
              child: SizedBox(
                height: 170,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    buildProduct(),
                    const SizedBox(
                      height: 10,
                    ),
                    buildProduct(),
                    const SizedBox(
                      height: 10,
                    ),
                    buildProduct(),
                    const SizedBox(
                      height: 10,
                    ),
                    buildProduct(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProduct() => SizedBox(
        width: 400,
        // padding: EdgeInsets.all(12),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Product name'),
                Flexible(
                  child: SizedBox(
                    width: 80,
                    height: 35, // Add this line
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: '2500',
                        labelStyle: TextStyle(
                            fontSize: 17, color: Colors.grey.shade500),
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
                      decoration: InputDecoration(
                        labelText: '300',
                        labelStyle: TextStyle(
                            fontSize: 17, color: Colors.grey.shade500),
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
                          onPressed: () {},
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
            )
          ],
        ),
      );

  //

  Widget getList(String history, int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          //  history.delete();
        },
        child: get(index, history));
  }

  ListTile get(int index, String history) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        //child: Image.asset('images/${history.name}.png', height: 40),
      ),
      title: const Text(
        // history.name,
        'historyname',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: const Text(
        'historydate',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Text(
        // history.amount,
        'Total price',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 19,
        ),
      ),
    );
  }

  Widget _head() {
    return Container(
        height: 100,
        decoration: const BoxDecoration(
          color: Color(0xff368983),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingScreen()));
                },
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const Text(
                ' 0.0 FCFA',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                  //if click on search icon
                  //scroll Container
                  //fixe float by=utton
                  //add quatity Textfiel
                  //change color on audio listview
                  //
                },
                icon: const Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));
    /*return Stack(
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xff368983),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: const Color.fromRGBO(250, 250, 250, 0.1),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => const SettingScreen()) );
                          },

                         child: const Icon(
                          Icons.settings,
                          size: 30,
                          color: Colors.white,
                        ),
                        )

                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 25, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Prix Total : FCFA',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ///
                  ///



                  ///
                ],
              ),
            ),
          ],
        ),
      ],
    ); */
  }
}
