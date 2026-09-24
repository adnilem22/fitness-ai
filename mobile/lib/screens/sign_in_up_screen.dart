
import 'package:flutter/material.dart';
import 'package:fitness_app/screens/login_screen.dart';
import 'package:fitness_app/screens/sign_up.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_app/models/user_model.dart';

class SignInUpScreen extends StatelessWidget {
  const SignInUpScreen({super.key});
  


@override
Widget build(BuildContext context){

 return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
           
            colors: [
             Color.fromARGB(255, 34, 255, 255),
             Color.fromARGB(255, 3, 16, 24),
            ],
          ),
        ),

    child: Column(
      children:[
        Padding(padding: const EdgeInsets.only(top:100),
        child: Image.asset(
                  'asset/logo_1.png', // Győződj meg róla, hogy az elérési út helyes!
                  height: 150, // Állítható méret
                  fit: BoxFit.contain,
                ),
        ),
         const SizedBox(height: 50),

Text(
  'Welcome',
    style: GoogleFonts.poppins(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
), 

const SizedBox(height: 50),

// SIGN IN gomb + navigáció
InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(userData: UserModel())),
    );
  },
  child: Container(
    height: 53,
    width: 320,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
     gradient: const LinearGradient(
                    colors: [
                    Color.fromARGB(255, 7, 238, 246),
                      Color.fromARGB(255, 3, 16, 24),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
    child: const Center(
      child: Text(
        'SIGN IN',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ),
),

const SizedBox(height: 20),

InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  SignupScreen(userData: UserModel())
),
    );
  },
  child: Container(
    height: 53,
    width: 320,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
     gradient: const LinearGradient(
                    colors: [
                    Color.fromARGB(255, 7, 238, 246),
                      Color.fromARGB(255, 3, 16, 24),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
    child: const Center(
      child: Text(
        'SIGN UP',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ),
),


      ]
    ),






      ),
 );











}
}