import 'package:fitness_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/models/user_model.dart';
import 'package:fitness_app/services/api_service.dart'; 

class FitnessLevelScreen extends StatefulWidget {
 final UserModel userData;
 const FitnessLevelScreen({super.key, required this.userData});


  @override
  State<FitnessLevelScreen> createState() => _FitnessLevelScreenState();
}

class _FitnessLevelScreenState extends State<FitnessLevelScreen> {
  final List<Map<String, dynamic>> levels = [
  {'id': 1, 'name': 'Beginner'},
  {'id': 2, 'name': 'Intermediate'},
  {'id': 3, 'name': 'Advanced'},
];
  final List<String> genders = ['Female', 'Male', 'Other'];
  final List<String> heights = List.generate(71, (index) => '${140 + index} ');
  final List<String> weights = List.generate(101, (index) => '${30 + index} ');
  final List<Map<String, dynamic>> goals = [
    {'id': 1, 'name': 'Lose weight'},
    {'id': 2, 'name': 'Gain muscle'},
    {'id': 3, 'name': 'Build strength'},
    {'id': 4, 'name': 'Increase endurance'},
    {'id': 5, 'name': 'Other'},
  ];



  int? selectedFitnessLevelId;
  String? selectedGender;
  String? selectedHeight;
  String? selectedWeight;
  int? selectedGoalId;
  InputDecoration _customDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 2.0,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.cyanAccent,
          width: 2.5,
        ),
      ),
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white24, // háttérszín a mező mögött
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  automaticallyImplyLeading: true, // fontos!
  iconTheme: const IconThemeData(color: Colors.cyan), // nyíl színe
  title: const Text(
    '               Personalize Your Journey',
    style: TextStyle(color: Colors.white,
    fontWeight: FontWeight.bold),
    
  ),
  backgroundColor: Colors.transparent,
  elevation: 0,
),

      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Padding(
          padding: const EdgeInsets.only(top: 170, left: 16, right: 16),
          child: Column(
            children: [
            DropdownButtonFormField<int>(
                decoration: _customDecoration('Select your fitness level'),
                dropdownColor: Colors.black87,
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                value: selectedFitnessLevelId, // 👈 csak 1 érték (pl. 1, 2 vagy 3)
                items: levels.map((level) {
                  return DropdownMenuItem<int>(
                    value: level['id'], // amit menteni akarsz
                    child: Text(level['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFitnessLevelId = value;
                  });
                },
              ),

               const SizedBox(height: 23),
             DropdownButtonFormField<int>(
  decoration: _customDecoration('Select your goal'),
  dropdownColor: Colors.black87,
  iconEnabledColor: Colors.white,
  style: const TextStyle(color: Colors.white),
  value: selectedGoalId,
  items: goals.map((goal) {
    return DropdownMenuItem<int>(
      value: goal['id'],
      child: Text(goal['name']),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedGoalId = value;
    });
  },
),

              const SizedBox(height: 23),
              DropdownButtonFormField<String>(
                decoration: _customDecoration('Select your gender'),
                dropdownColor: Colors.black87,
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                items: genders.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                value: selectedGender,
                onChanged: (newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
              ),
              const SizedBox(height: 23),
              DropdownButtonFormField<String>(
                decoration: _customDecoration('Select your height'),
                dropdownColor: Colors.black87,
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                items: heights.map((height) {
                  return DropdownMenuItem(
                    value: height,
                    child: Text(height),
                  );
                }).toList(),
                value: selectedHeight,
                onChanged: (newValue) {
                  setState(() {
                    selectedHeight = newValue;
                  });
                },
              ),
              const SizedBox(height: 23),
              DropdownButtonFormField<String>(
                decoration: _customDecoration('Select your weight'),
                dropdownColor: Colors.black87,
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                items: weights.map((weight) {
                  return DropdownMenuItem(
                    value: weight,
                    child: Text(weight),
                  );
                }).toList(),
                value: selectedWeight,
                onChanged: (newValue) {
                  setState(() {
                    selectedWeight = newValue;
                  });
                },
              ), 

                  const SizedBox(height: 70),

                        InkWell(
                          onTap: () async {
  if (selectedFitnessLevelId == null ||
      selectedGoalId == null ||
      selectedGender == null ||
      selectedHeight == null ||
      selectedWeight == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Töltsd ki az összes mezőt!')),
    );
    return;
  }
  
  widget.userData.fitnessLevelId = selectedFitnessLevelId;
  widget.userData.goalId = selectedGoalId;
  widget.userData.gender = selectedGender;
  widget.userData.height = selectedHeight;
  widget.userData.weight = selectedWeight;
  
   print(widget.userData.toJson());

        UserModel? updatedUser = await registerUser(widget.userData);

      if (updatedUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userData: updatedUser),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hiba a mentés során!')),
        );
      }
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
                                    color: Colors.white,
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
            ],
          ),
        ),
      ),
    );
  }
}
