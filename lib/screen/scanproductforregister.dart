import 'package:fiboutiquesv1/Providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ScanProdut extends StatefulWidget {
  const ScanProdut({Key? key}) : super(key: key);

  @override
  State<ScanProdut> createState() => _ScanProdutState();
}

class _ScanProdutState extends State<ScanProdut> {
  String _scanBarcode = 'Scan a barcode';
  bool _scanning = false;
  List<Map<dynamic, dynamic>> selectedProducts = <Map<dynamic, dynamic>>[];
   

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    _scanning = true;

    while (_scanning) {
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Arreter', true, ScanMode.BARCODE);
        print(barcodeScanRes);
          Provider.of<DatabaseProvider>(context, listen: false).onSelectbarcode(barcodeScanRes);
       
      } on PlatformException {
        barcodeScanRes = 'Failed to get platform version.';
      }

      if (!mounted || barcodeScanRes == '-1') {
        _stopScanning();
      }

      setState(() {
        _scanBarcode = barcodeScanRes;
      });
    }
  }

  void _stopScanning() {
  
    setState(() {
      _scanning = false;
    });
  }

@override
  void initState() {
    
    super.initState();
  }

//
 
  //chercher product n

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset(
                'assets/mpto.png', 
                height: 200, 
                width: 200, 
              ),
            ),
            const SizedBox(height: 20),
           Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Ajoutez ici la logique pour lancer la caméra
            Fluttertoast.showToast(msg: "Cette fonctionnalité n'est pas encore disponible!!!");
          },
          child: const Icon(
            Icons.remove_red_eye_rounded,
            color: Color(0xff368983),
          ),
        ),
        const Text(
          'Camera',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff368983)),
        ),
      ],
    ),
    Column(
      children: [
        ElevatedButton(
          onPressed: () {
            scanBarcodeNormal();
          },
          child: const Icon(
            Icons.qr_code_2_outlined,
            color: Color(0xff368983),
          ),
        ),
        const Text(
          'Scanner',
          style: TextStyle(
             fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff368983)),
        ),
      ],
    ),
  ],
)

          ],
        ),
      ),
    );
  }
}
