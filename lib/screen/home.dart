

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:fiboutiquesv1/screen/settings.dart';
import 'package:fiboutiquesv1/widgets/search_data.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomeScree extends StatefulWidget {
  const MyHomeScree({super.key});

  @override
  State<MyHomeScree> createState() => _MyHomeScreeState();
}



class _MyHomeScreeState extends State<MyHomeScree> {

  Color mcolor = const Color(0xff368983);
 
    AudioPlayer audioPlayer = AudioPlayer();
  bool isRecording = false;
  bool isPlaying = false;
  String currentRecordingPath = '';
  List<String> audioPaths = [];

  @override
  void initState() {
    super.initState();
    loadAudioPaths();
  }

  // Shared Preferences
  Future<void> loadAudioPaths() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAudioPaths = prefs.getStringList('audioPaths') ?? [];
    setState(() {
      audioPaths = savedAudioPaths;
    });
  }

  Future<void> saveAudioPaths() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('audioPaths', audioPaths);
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
    if (await Permission.microphone.request().isGranted) {
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

  Future<void> _stopRecording() async {
    await Record().stop();
    setState(() {
      isRecording = false;
    });
    _loadAudioFiles();
  }

   Future<void> _playAudio(String path ) async {
    if (!isPlaying) {
      await audioPlayer.play(path as Source);
      setState(() {
        isPlaying = true;
      });
    } else {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    }
  
}

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    if (!(await Permission.microphone.isGranted)) {
      await Permission.microphone.request();
    }
  }
 

 

 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
       // height: fabHeight,
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
      body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                SizedBox(height: 70, child: _head()),
                const SizedBox(
                        height: 10,
                      ),
            ///listviw audio     
                 
             
Visibility(
  visible: audioPaths != null && audioPaths.isNotEmpty,
  child : Container(
  color: Colors.grey.withOpacity(0.1),
  height: 100,
 // padding: EdgeInsets.all(8),
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: audioPaths.length,
    itemBuilder: (context, index) {
      final audioPath = audioPaths[index];
      return Container(
          
        width: 200, // Set a finite width for each ListTile
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2:30'),
                    IconButton(onPressed: () {
                      
                      setState(() {
                        audioPaths.removeAt(index);
                        saveAudioPaths();
                      });
                    }, icon: Icon(Icons.close)),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2, // Adjust the flex factor as needed
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        _playAudio(audioPath);
                      },
                      icon: isPlaying ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    LinearPercentIndicator(
                      width: 140,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
),
 ),


                 
                 
                 SizedBox(
                  height: 40,
                  child: Padding (

                    padding: const EdgeInsets.all(10),

                 child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: (){}, 
                      icon : Icon(Icons.shopping_cart,
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
                        icon :Icon(
                          Icons.add,
                       color: mcolor,
                       size: 25,
                       shadows: const [
                        BoxShadow(
                            blurRadius: 2,
                            
                        ),
                       ],
                      
                       ),
                        onPressed : () {}
                       ),
                    ],
                  ),
                    ),
                 ),
                 //
                
                    Expanded(
                      child: 
                 SizedBox(
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      
                        buildProduct(),
                        const SizedBox(height: 10,),
                        buildProduct(),
                        const SizedBox(height: 10,),
                        buildProduct(),
                        const SizedBox(height: 10,),
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

Widget buildProduct()   =>     SizedBox(
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
  height: 35,// Add this line
     child: TextField(
    
      decoration: InputDecoration(
        labelText: '2500',
        labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: Color(0xff368983)),
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
        labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: Color(0xff368983)),
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
                                        IconButton(onPressed: (){},
                                         icon : const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            ),)
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
      child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         IconButton(onPressed: (){
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const SettingScreen()) );
         }, 
         icon:  const Icon(Icons.settings,
          size: 30,
          color: Colors.white,
          ),),
          const Text(' 0.0 FCFA',
          style: TextStyle(
            fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          ),
          ),
          IconButton(
          onPressed: (){
            showSearch(
              context: context, 
              delegate: DataSearch());
              //if click on search icon
              //scroll Container
              //fixe float by=utton
              //add quatity Textfiel
              //change color on audio listview
              //
          },
           icon: const Icon(Icons.search,
          size: 30,
          color: Colors.white,
          ),),
           
              
        ],
      ),
      
      )
    );
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