import 'dart:async';

import 'package:fiboutiquesv1/screen/verifyotp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  static String verify = '';
  static String number = '';

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  var phone = "";
  bool isLoading = false;

  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    countryController.text = "+221";
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            background_container(context),
            Positioned(
              top: 120,
              child: main_container(),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container main_container() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: 250,
      width: 340,
      child: Column(
        children: [
          const SizedBox(height: 50),
          phonenumber(),
          const SizedBox(height: 25),
          save(),
        ],
      ),
    );
  }

  //
  Padding phonenumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: const Color(0xff368983)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 40,
              child: TextField(
                controller: countryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const Text(
              "|",
              style: TextStyle(fontSize: 33, color: Colors.grey),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  phone = value;
                  print(phone);
                },
                controller: _phoneController,
                maxLength: 9,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "77XXXXXXX",
                  counterText: '',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  

  

  GestureDetector save() {
    return GestureDetector(
      onTap: () async {
          setState(() {
        isLoading = true; });
              Timer(
        const Duration(seconds: 35),
        () {
          setState(() {
            isLoading = false; // Set isLoading to false when the timer is done.
          });

          try {
            FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: countryController.text + phone,
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent:
                                (String verificationId, int? resendToken) {
                              SettingScreen.verify = verificationId;
                              SettingScreen.number = phone;
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const VerifOTPCode()));

                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                            setState(() {
                            isLoading = false;
                           });
                          }
                        }
        },
      );
       
      },
      child:isLoading
            ? Center(
             child : Padding(padding:const EdgeInsets.all(10) ,
             child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: const Color(0xff368983),
                    backgroundColor: const Color(0xff368983).withOpacity(0.1),
                    value: null,
                    strokeWidth: 6.0,
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  const Text(
                      'Merci de patienter quelques instants pour recevoir un code de validation par SMS svp !',
                      style: TextStyle(
                        color:  Color(0xff368983)
                      ),
                      ),
                ],
              )
            ),
             ) : Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff368983),
        ),
        width: 120,
        height: 50,
        child: 
            const Text(
                'Enregistrer',
                style: TextStyle(
                  fontFamily: 'f',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
      ),
    );
  }
  // ignore: non_constant_identifier_names
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
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const LoginScreen()));
                      },
                      child: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white),
                    ),
                    const Text(
                      'Entrez votre numéro',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    const Opacity(
                        opacity: 0.0,
                        child: Padding(
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

  ///
}