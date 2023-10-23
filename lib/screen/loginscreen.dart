import 'package:fiboutiquesv1/Database/user.dart';
import 'package:fiboutiquesv1/main.dart';
import 'package:fiboutiquesv1/screen/motdepass_oublier.dart';
import 'package:fiboutiquesv1/screen/settings.dart';
import 'package:fiboutiquesv1/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{
   final TextEditingController _passwordController = TextEditingController();
   bool _isPasswordVisible = false;
   bool _isVerifying = false;
   late AnimationController _controller;


 
 login (){
  setState(() {
    _isVerifying = true;
  });
   String enteredPassword = _passwordController.text;
        
        User? savedUser = users.get('current_user');

        if (savedUser != null && savedUser.password == enteredPassword) {
          savedUser.isLoggedIn = true;
          Future.delayed(const Duration(seconds: 3), (){
               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Bottom()));

          });
          
    
        
            
        } else {
          _passwordController.text.trim();
            
         showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Erreur',
               style: TextStyle(
                color:  Colors.redAccent,
                fontWeight: FontWeight.bold,
               ),
              ),
              content: const Text('Mot de passe incorrect. Veuillez réessayer svp!',
                   style: TextStyle(
                    color:  Color(0xff368983),

                   ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK',
                   style: TextStyle(
                    color:  Color(0xff368983),
                    fontWeight: FontWeight.bold,
                   ),
                  ),
                ),
              ],
            ),
          );
           setState(() {
    _isVerifying = false;
  });
        }
 }
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
   _controller.dispose();
    super.dispose();
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
      child: _isVerifying
          ? Center(
            child:  Container(
    decoration: BoxDecoration(
      color: const Color(0xff368983).withOpacity(0.7),  // Le Container interne est transparent
      borderRadius: BorderRadius.circular(10),
    ),
    height: 175,
    width: 175,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
         child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                const SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff368983)),
                  ),
                ),
                const SizedBox(height: 10), // Espacement entre le CircularProgressIndicator et le Text widget
               AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              int numDots = 1 + (_controller.value * 3).floor();
              String dots = '.' * numDots;
              return Text(
                'Connexion en cours$dots',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              );
            },
          ),
              ],
            ),
      ),
    ),
  ),

 )
          :Column(
        children: [
          const SizedBox(height: 50),
          password(),
            const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             save(),
           const SizedBox(width: 15),
          inscriprion(),
           ],
          ),
          const SizedBox(height: 25),
          motdepassoublier(),
        ],
      ),
    );
  }

GestureDetector motdepassoublier() {
      return GestureDetector(
      onTap: () async {
       Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Motdepasseoublier()));
      },
      child: const Padding(
        padding: EdgeInsets.only(left: 15),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
          'Mot de passe oublié ?',
          style: TextStyle(
            fontFamily: 'f',
            fontWeight: FontWeight.w600,
             color: Color(0xff368983),
            fontSize: 17,
          ),
        ),
        ],
      ),
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
          labelText: 'password',
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
  //

  GestureDetector save() {
    return GestureDetector(
      onTap: () async {
       await login();
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
          'Connexion',
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
  GestureDetector inscriprion() {
    return GestureDetector(
      onTap: () async {
       Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const SettingScreen()));
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
          'Inscription',
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
          child: const Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   
                    Text(
                      'Se connecter',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Opacity(opacity: 0.0, child: Padding(
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