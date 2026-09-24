import 'package:fitness_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_app/screens/sign_in_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required UserModel userData});

  @override
  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
    

            // Logó
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset(
                'asset/logo_1.png',
                height: 320,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 80),

            // Főcím
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Begin your fitness journey with AI',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 10),

            // Alcím
            Text(
              'Personalized workouts powered by smart technology',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            // Gomb
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInUpScreen(),
                  ),
                );
              },
              child: Container(
                height: 60,
                width: 270,
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
                child: Center(
                  child: Text(
                    'Get Started',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
