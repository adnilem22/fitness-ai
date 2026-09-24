import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseUploader {
  final String apiUrl = "https://exercisedb.p.rapidapi.com/exercises?limit=0";
  final String phpUrl =
      "http://localhost/flutter_mysql/api.php"; // Cseréld le a PHP fájl elérési útjára

  Future<void> fetchAndUploadExercises() async {
    try {
      // 1. Gyakorlatok lekérése az API-ból
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "X-RapidAPI-Host": "exercisedb.p.rapidapi.com",
          "X-RapidAPI-Key": "725f904e9dmshbe1a532a69910c9p10fb8djsn3e414cc18468"
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> exercises = json.decode(response.body);

        // 2. Adatok feltöltése a PHP backendre
        final uploadResponse = await http.post(
          Uri.parse(phpUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(exercises),
        );

        if (uploadResponse.statusCode == 200) {
          print("Sikeres feltöltés: ${uploadResponse.body}");
        } else {
          print("Hiba a feltöltés során: ${uploadResponse.body}");
        }
      } else {
        print("Hiba az API hívás során: ${response.statusCode}");
      }
    } catch (e) {
      print("Hiba: $e");
    }
  }
}
//4NVO0ut9uLFbisjCxDi5yRXvRUQtjChF apikey
//sk-or-v1-cede042ea8741331397ca9cfcbddd93288d52727d68812815f502d05eab62fce3

// C8lTSPuQRgRAZlf72nUjBEKgC1Vg39rp
//mistral