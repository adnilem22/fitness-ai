import 'package:flutter/material.dart';
import 'package:fitness_app/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.cyan,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 60, color: Colors.cyan.shade700),
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileCard(Icons.person, "Name", user.name),
            _buildProfileCard(Icons.transgender, "Gender", user.gender),
            _buildProfileCard(Icons.cake, "Birth Date", user.birthDate),
            _buildProfileCard(Icons.phone, "Phone", user.phoneNumber),
            _buildProfileCard(Icons.height, "Height", "${user.height} cm"),
            _buildProfileCard(Icons.monitor_weight, "Weight", "${user.weight} kg"),
            _buildProfileCard(Icons.flag, "Goal", getGoalName(user.goalId)),
            _buildProfileCard(Icons.fitness_center, "Fitness Level", getFitnessLevel(user.fitnessLevelId)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(IconData icon, String label, String? value) {
    return Card(
      color: Colors.white24,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.cyanAccent),
        title: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value ?? "-",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
    
  }

  String getGoalName(int? id) {
    switch (id) {
      case 1:
        return 'Lose weight';
      case 2:
        return 'Gain muscle';
      case 3:
        return 'Build strength';
      case 4:
        return 'Increase endurance';
      case 5:
        return 'Other';
      default:
        return 'Unknown';
    }
  }

  String getFitnessLevel(int? id) {
    switch (id) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Intermediate';
      case 3:
        return 'Advanced';
      default:
        return 'Unknown';
    }
  }
}
