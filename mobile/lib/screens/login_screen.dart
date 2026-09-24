import 'package:fitness_app/screens/home_screen.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/screens/sign_up.dart';
import 'package:fitness_app/models/user_model.dart';



class LoginScreen extends StatefulWidget {
  final UserModel userData;
  const LoginScreen({super.key, required this.userData});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
   
  bool passwordVisible = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                      Color.fromARGB(255, 7, 238, 246),
                      Color.fromARGB(255, 3, 16, 24),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 80.0, left: 22),
              child: Text(
                'Sign in!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // White Container for the form
          Padding(
            padding: const EdgeInsets.only(top: 200.0,bottom:40.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text(
                          'Phone number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 5, 30, 65),
                          ),
                        ),
                      ),
                    ),
                   TextField(
                    controller: passwordController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                        label: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:Color.fromARGB(255, 5, 30, 65),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xff281537),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    InkWell(
                          onTap: () async {
                          UserModel? user =await loginUser(
                              phoneController.text.trim(),
                              passwordController.text.trim(),
                            );

                            if (user != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Sikeres bejelentkezés!")),
                              ); 
                              print("A HomeScreen-nek továbbított user.goalId: ${widget.userData.goalId}");

                              Navigator.pushReplacement(
                                context,
                               MaterialPageRoute(
                                  builder: (context) => HomeScreen(userData: user),
                                  
                                ),

                              );

                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Hibas telefonszam vagy jelszo!")),
                              );
                            }
                          },

                    child: Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                           Color.fromARGB(255, 7, 238, 246),
                           Color.fromARGB(255, 3, 16, 24),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    ),
                    const SizedBox(height: 150),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Don't have account?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                           InkWell(
                            onTap: ()  {
                            
                             Navigator.push(
                                context,
                               MaterialPageRoute(builder: (context) => SignupScreen(userData: UserModel())),
                               );
                          },
                         child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                           ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        
      ),
      
    );
  }
  void _showError(String message) {
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red.shade600,
    ),
  );
}
}