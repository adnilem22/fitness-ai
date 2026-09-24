import 'package:fitness_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/models/exercise.dart';
import 'exercise_card.dart';

class ExerciseListScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final UserModel userData;

  const ExerciseListScreen({
    Key? key, 
    required this.exercises, 
    required this.userData
  }) : super(key: key);

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Csoportosítja a gyakorlatokat a nap alapján
  Map<String, List<Exercise>> _groupByDay(List<Exercise> exercises) {
    final Map<String, List<Exercise>> grouped = {};
    
    for (var exercise in exercises) {
      if (!grouped.containsKey(exercise.day)) {
        grouped[exercise.day] = [];
      }
      grouped[exercise.day]!.add(exercise);
    }
    
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedExercises = _groupByDay(widget.exercises);
    
    return Scaffold(
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
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Workout Plan",
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${groupedExercises.length} day(s) • ${widget.exercises.length} exercises",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: groupedExercises.isEmpty
                      ? Center(
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.fitness_center,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'No exercises found',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Generate a new workout to get started',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: ListView(
                              padding: const EdgeInsets.all(20),
                              children: _buildDayList(groupedExercises),
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

  List<Widget> _buildDayList(Map<String, List<Exercise>> groupedExercises) {
    List<Widget> widgets = [];
    int dayIndex = 0;
    
    for (var entry in groupedExercises.entries) {
      final day = entry.key;
      final dayExercises = entry.value;
      
      // Day Header
      widgets.add(
        Container(
          margin: EdgeInsets.only(
            top: dayIndex == 0 ? 0 : 30,
            bottom: 15,
          ),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color.fromARGB(255, 34, 255, 255).withOpacity(0.3),
                const Color.fromARGB(255, 34, 255, 255).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color.fromARGB(255, 34, 255, 255).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 34, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${dayIndex + 1}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 3, 16, 24),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${dayExercises.length} exercises',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ),
      );
      
      // Exercises for this day
      for (int i = 0; i < dayExercises.length; i++) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ExerciseCard(
              exercise: dayExercises[i],
              index: i,
            ),
          ),
        );
      }
      
      dayIndex++;
    }
    
    return widgets;
  }
}