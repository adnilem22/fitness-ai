import 'package:flutter/material.dart';
import 'package:fitness_app/models/user_model.dart';
import 'package:fitness_app/models/exercise.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'exercise_list_screen.dart';
import 'package:fitness_app/screens/sign_in_up_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userData;

  const HomeScreen({Key? key, required this.userData}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool loading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _animationController.forward();
  }

  final Map<int, String> goalNames = {
  1: 'Weight Loss',
  2: 'Gain Muscle',
  3: 'Build Strength',
  4: 'Increase Endurance',
  5: 'General Fitness',
};

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> generateWorkout() async {
    setState(() => loading = true);

  final stopwatch = Stopwatch()..start(); //  Start timer

    try {
      final response = await http.get(
        Uri.parse("http://10.64.0.85/flutter_mysql/generate_user_plan.php?user_id=${widget.userData.id}"),
        headers: {"Accept": "application/json"},
      ).timeout(const Duration(seconds: 30));

       stopwatch.stop(); // Stop timer here
       final duration = stopwatch.elapsed;
    debugPrint(" AI generation time: ${duration.inSeconds}.${duration.inMilliseconds % 1000}s");
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['workout_plan'] != null) {
          final plan = data['workout_plan'] as List;

 List<Exercise> exercises = [];

for (var dayPlan in plan) {
  // 1) pull out the day string
  final String day = dayPlan['day'] as String;

  // 2) pull out that day's exercises
  final List exList = dayPlan['exercises'] as List;
  for (var exJson in exList) {
    // create the Exercise from JSON…
    final ex = Exercise.fromJson(exJson as Map<String, dynamic>);
    // …then inject the day
    ex.day = day;
    // finally add to the list
    exercises.add(ex);
  }
}


          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExerciseListScreen(
                exercises: exercises,
                userData: widget.userData,
              ),
            ),
          );
        } else {
          _showError('Workout generation failed.');
        }
      } else {
        _showError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Network error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> getSavedWorkout() async {
    setState(() => loading = true);

    try {
      final response = await http.get(
        Uri.parse("http://10.64.0.85/flutter_mysql/get_saved_workout.php?user_id=${widget.userData.id}"),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['workout_plan'] != null) {
          List<Exercise> exercises = (data['workout_plan'] as List)
              .map((e) => Exercise.fromJson(e))
              .toList();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExerciseListScreen(
                exercises: exercises,
                userData: widget.userData,
              ),
            ),
          );
        } else {
          _showError("No saved plan found.");
        }
      } else {
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Failed to fetch saved workout: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
    bool isPrimary = true,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: isPrimary
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color.fromARGB(255, 34, 255, 255).withOpacity(0.8),
                  const Color.fromARGB(255, 34, 255, 255),
                ],
              )
            : LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.2),
                ],
              ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 34, 255, 255).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isPrimary ? const Color.fromARGB(255, 3, 16, 24) : Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPrimary ? const Color.fromARGB(255, 3, 16, 24) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    automaticallyImplyLeading: false,
    actions: [
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.white),
        tooltip: 'Log out',
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SignInUpScreen()),
            (Route<dynamic> route) => false, // törli az összes előző route-ot
          );
        },
      ),
    ],
  ),
  extendBodyBehindAppBar: true,
      body: Container(
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
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Custom App Bar
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                widget.userData.name ?? 'User',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Main Content
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Goal Card
                          Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.track_changes,
                                  color: Colors.white,
                                  size: 48,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  "Your Fitness Goal",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Goal: ${goalNames[widget.userData.goalId] ?? 'Unknown'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color.fromARGB(255, 34, 255, 255),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Action Buttons
                          if (loading)
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 34, 255, 255),
                                    ),
                                    strokeWidth: 3,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Loading your workout...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                _buildGradientButton(
                                  text: "Generate New Workout",
                                  onPressed: generateWorkout,
                                  icon: Icons.add_circle_outline,
                                  isPrimary: true,
                                ),
                                _buildGradientButton(
                                  text: "View My Saved Plan",
                                  onPressed: getSavedWorkout,
                                  icon: Icons.bookmark_outline,
                                  isPrimary: false,
                                ),
                              ],
                            ),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}