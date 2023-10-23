import 'package:fiboutiquesv1/Database/user.dart';
import 'package:fiboutiquesv1/main.dart';
import 'package:fiboutiquesv1/screen/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Motdepasseoublier extends StatefulWidget {
  const Motdepasseoublier({super.key});

  @override
  State<Motdepasseoublier> createState() => _MotdepasseoublierState();
}

class _MotdepasseoublierState extends State<Motdepasseoublier> {
   final TextEditingController _passwordController = TextEditingController();
   final TextEditingController _confpasswordController = TextEditingController();
   bool _isPasswordVisible = false;
   bool _confisPasswordVisible = false;

   //update password
   modifpassword() async{
      String newPassword = _passwordController.text;
      String confPassword = _confpasswordController.text;

       if (newPassword != confPassword) {
    Fluttertoast.showToast(msg: "Les deux mots de passe doivent être identiques");
  } else {
      User user = users.get('current_user');
      user.modifyPassword(newPassword);
       await users.put('current_user', user);
        Fluttertoast.showToast(msg: "Modification du mot de passe réussie!!");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }


    
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
      height: 350,
      width: 340,
      child: Column(
        children: [
          const SizedBox(height: 50),
          password(),
            const SizedBox(height: 25),
          confpassword(),
            const SizedBox(height: 25),
             updatepasswordwidget(),
        ],
      ),
    );
  }

  Padding password() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _passwordController,
         obscureText: !_isPasswordVisible,
       keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'nouveau password',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Color(0xff368983))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Color(0xff368983))),
              suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xff368983),
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        ),
      ),
    );
  }
Padding confpassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _confpasswordController,
         obscureText: !_confisPasswordVisible,
       keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'confirmer password',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Color(0xff368983))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Color(0xff368983))),
              suffixIcon: IconButton(
          icon: Icon(
            _confisPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xff368983),
          ),
          onPressed: () {
            setState(() {
              _confisPasswordVisible = !_confisPasswordVisible;
            });
          },
        ),
        ),
      ),
    );
  }
  //

  GestureDetector updatepasswordwidget() {
    return GestureDetector(
      onTap: () async {
       await modifpassword();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff368983),
        ),
        width: 120,
        height: 50,
        child: const Text(
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
                         Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                      child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                    ),
                    const Text(
                      'Nouveau mot de passe',
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