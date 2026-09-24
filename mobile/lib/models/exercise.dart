class Exercise {
  final String exerciseName;
  final String bodyPart;
  final String equipment;
  final String target;
  final int sets;
  final int reps;
  final int weight;
  final int restTime;
  String day;
  final String? tutorialUrl;
 

  Exercise({
    required this.exerciseName,
    required this.bodyPart,
    required this.equipment,
    required this.target,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.restTime,
     this.day='',
     this.tutorialUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
  
    return Exercise(
      exerciseName: json['exercise_name'],
      bodyPart:      json['body_part'],
      equipment:     json['equipment'],
      target:        json['target'],
      sets:          json['sets'],
      reps:          json['reps'],
      weight:        json['weight'],
      restTime:      json['rest_time'],
     // day:           json['day'],
      tutorialUrl: json['tutorial_url'],
    );
  }
}
