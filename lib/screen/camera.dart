import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;

  String  _scanBarcode  = 'Scan a barcode';

Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }
    Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _takePicture() async {
    try {
      if (_controller.value.isInitialized) {
        XFile file = await _controller.takePicture();
        String filePath = file.path;
        print("Image captured and saved at: $filePath");
      }
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Camera Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              width: 300,
              child: CameraPreview(_controller),
            ),
            const SizedBox(height: 20),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               ElevatedButton(
              onPressed: _takePicture,
              child: const Icon(Icons.camera_alt,
              color: Color(0xff368983),
              )
            ),
            ElevatedButton(
              onPressed: (){
                 scanBarcodeNormal();
              },
              child: const Icon(
                Icons.qr_code_2_outlined,
                color: Color(0xff368983),
              ),
              
            ),
            
            ],
           ),
           
          ],
        ),
      ),
    );
  }
}

