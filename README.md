# Fitness AI Assistant

A full-stack mobile application that generates personalized fitness plans and workouts powered by Artificial Intelligence (OpenAI GPT API).

---

## Features

- Personalized Workout Generation: Tailored fitness plans created dynamically based on user goals, physical metrics, and fitness levels.
- AI-Powered Recommendations: Integrates OpenAI API to generate structured workout routines and exercises.
- User Authentication & Profiles: Secure registration and login functionality.
- Saved Workouts & Tutorials: Access saved training programs and detailed exercise instructions/tutorials.

---

## Tech Stack

### Frontend (Mobile)
- Framework: Flutter (Dart)
- Networking: HTTP Client for API endpoints

### Backend
- Language: PHP 8.x
- Database: MySQL
- Dependencies: Composer & GuzzleHTTP (for OpenAI API integration)
- API Architecture: RESTful JSON APIs

---
## Setup & Running 
### 1. Backend Setup:
   - Import database.sql into your local MySQL server.
   - Host the PHP scripts using XAMPP, WAMP, or any local PHP server.
   - Set up your local database credentials and OpenAI API key in the PHP backend files.

### 2. Mobile Setup:
   - Navigate to the mobile/ directory.
   - Run flutter pub get to install all dependencies.
   - Run flutter run to launch the mobile application.

## Repository Structure

```text
fitness-ai/
├── backend/            # PHP APIs, database schema, and OpenAI integration
│   ├── api.php
│   ├── generate_user_plan.php
│   ├── get_saved_workout.php
│   ├── get_tutorial.php
│   ├── insert_user.php
│   ├── login.php
│   └── database.sql
└── mobile/             # Flutter cross-platform mobile application codebase

