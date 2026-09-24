import 'package:flutter/material.dart';
import 'package:fitness_app/screens/login_screen.dart';
import 'package:fitness_app/screens/fitness_screen.dart';
import 'package:fitness_app/models/user_model.dart';




class SignupScreen extends StatefulWidget {
  final UserModel userData;
  const SignupScreen({super.key, required this.userData});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  bool passwordVisible = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _birthDateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

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
              padding: EdgeInsets.only(top: 100.0, left: 22),
              child: Text(
                'Create your account!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0, bottom: 40.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 5, 30, 65),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _birthDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
                        label: Text(
                          'Birth date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 5, 30, 65),
                          ),
                        ),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                    TextField(
                      controller: _phoneController,
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
                      controller: _passwordController,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 5, 30, 65),
                          fontWeight: FontWeight.bold,
                        ),
                        helperText: "Password must contain numbers and special characters",
                        helperStyle: const TextStyle(color: Colors.green),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                        alignLabelWithHint: false,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 70),
                    Container(
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
                      child: InkWell(
                        onTap: () {
                          widget.userData.name = _nameController.text;
                          widget.userData.birthDate = _birthDateController.text;
                          widget.userData.phoneNumber = _phoneController.text;
                          widget.userData.password = _passwordController.text;
                            
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FitnessLevelScreen(userData: widget.userData),
                            ),
                          );  


                        },
                        
                        child: const Center(
                          child: Text(
                            'NEXT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen(userData: UserModel())),
                              );
                            },
                            child: const Text(
                              "Sign in",
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
}
