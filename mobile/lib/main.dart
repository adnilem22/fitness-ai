import 'package:fitness_app/screens/login_screen.dart';
import 'package:fitness_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/screens/sign_up.dart';
import 'package:fitness_app/screens/sign_in_up_screen.dart';
import 'package:fitness_app/screens/fitness_screen.dart';
import 'package:fitness_app/screens/profile_screen.dart';
import 'package:fitness_app/models/user_model.dart';
import 'package:fitness_app/screens/home_screen.dart';
import 'package:fitness_app/screens/exercise_list_screen.dart';


//import 'screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    
      home: WelcomeScreen(userData: UserModel()),

         
    );
  }
  
}

 //home: FitnessLevelScreen(userData: UserModel()),