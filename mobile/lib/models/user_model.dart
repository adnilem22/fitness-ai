class UserModel {
  int? id; 
  String? name;
  String? birthDate;
  String? phoneNumber;
  String? password;
  int? fitnessLevelId;
  int? goalId;
  String? gender;
  String? height;
  String? weight;

  UserModel({
    this.id, 
    this.name,
    this.birthDate,
    this.phoneNumber,
    this.password,
    this.fitnessLevelId,
    this.goalId,
    this.gender,
    this.height,
    this.weight,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id'].toString()),
      name: json['name'],
      birthDate: json['birth_date'],
      phoneNumber: json['phone_number'],
      password: json['password'],
      fitnessLevelId: int.tryParse(json['fitness_level_id'].toString()),
      goalId: int.tryParse(json['goal_id'].toString()),
      gender: json['gender'],
      height: json['height'].toString(),
      weight: json['weight'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id?.toString() ?? '', 
      'name': name ?? '',
      'birth_date': birthDate ?? '',
      'phone_number': phoneNumber ?? '',
      'password': password ?? '',
      'fitness_level_id': fitnessLevelId?.toString() ?? '',
      'goal_id': goalId?.toString() ?? '',
      'gender': gender ?? '',
      'height': height ?? '',
      'weight': weight ?? '',
    };
  }
}
