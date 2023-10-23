import 'package:fiboutiquesv1/screen/makepassword.dart';
import 'package:fiboutiquesv1/screen/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';

class VerifOTPCode extends StatefulWidget {
  //final String verificationId;
  const VerifOTPCode({Key? key}) : super(key: key);


  @override
  State<VerifOTPCode> createState() => _VerifOTPCodeState();
}

class _VerifOTPCodeState extends State<VerifOTPCode> {
   FirebaseAuth auth = FirebaseAuth.instance;
  var smsCode = '';
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      
      body: SafeArea(
        child: Stack(
           alignment: Alignment.center,
           children: [
            background_container(context),
            Positioned(
              top: 120,
              child:  Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            ),
           height: 350,
           width: 340,
        
            
          child: Padding(padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Merci de renseigner le code OTP que vous venez de recevoir par SMS.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                 autofocus: true,
                showCursor: true,
                onCompleted: (pin) => print(pin),
                onChanged: (value) {
                    smsCode = value;
                  },
                  
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff368983),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                   //   Navigator.of(context)
             // .push(MaterialPageRoute(builder: (context) => const MakePassword()));
             try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: SettingScreen.verify,
                                  smsCode: smsCode);
                          await auth.signInWithCredential(credential);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const MakePassword(),
                              ),
                              (route) => false);
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                            Fluttertoast.showToast(msg: "Le code de vérification que vous avez entrer n'est pas valide. Veuillez vérifier et saisir à nouveau le code de vérification correct.");
                          }
                        }
                    },
                    child: const Text(
                      "Verification",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    
                    ),
                    ),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'phone',
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Modifier numéro ?",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                ],
              )
            ],
          ),),
        ),
      ),
              
           ],
      ),
      ),
    );
  }
    Column background_container(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: const BoxDecoration(
            color: Color(0xff368983),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                         Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const SettingScreen()));
                      },
                      child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                    ),
                    const Text(
                      'Verification code OTP',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    const Opacity(opacity: 0.0, child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
              ),
              child: Icon(
                      Icons.attach_file_outlined,
                      color: Colors.white,
                    ),
            ))
                    
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}