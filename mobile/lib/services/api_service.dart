import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitness_app/models/user_model.dart';

Future<UserModel?> registerUser(UserModel userData) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.64.0.85/flutter_mysql/insert_user.php'),
      body: userData.toJson(),
    );

    if (response.statusCode == 200) {
      print("Szerver válasz: ${response.body}");

      // ha visszajön JSON, visszatölthetnénk az új UserModel-t
      if (response.body.contains('{') && response.body.contains('}')) {
        var json = jsonDecode(response.body);
        return UserModel.fromJson(json); // ⬅ ezt implementálni kell
      }

      // ha csak sima 'success', akkor térjünk vissza a meglévő modellel
      if (response.body.contains('success')) {
        return userData;
      }

      return null;
    } else {
      return null;
    }
  } catch (e) {
    print("Hiba: $e");
    return null;
  }
}


Future<UserModel?> loginUser(String phone, String password) async {
  try {
    
    final response = await http.post(
      Uri.parse('http://10.64.0.85/flutter_mysql/login.php'),
      body: {
        'phone_number': phone,
        'password': password,
        
      },
    );
  
    if (response.statusCode == 200) {

      final Map<String, dynamic> data = jsonDecode(response.body);

            print("Login JSON: ${response.body}");
      if (data.containsKey('status') && data['status'] == 'error') {
        // pl. "hibás jelszó" vagy "nincs ilyen felhasználó"
        print("Login hiba: ${data['message']}");
        return null;
      }

      return UserModel.fromJson(data);
    } else {
      print("HTTP hiba: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print('Login kivétel: $e');
    return null;
  }
  
}


