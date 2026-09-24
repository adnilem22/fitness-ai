<?php


require 'vendor/autoload.php';

use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;


$servername = "localhost";
$username   = "root";   
$password   = "";   
$dbname     = "sys";    

$conn = new mysqli($servername, $username, $password, $dbname);


if ($conn->connect_error) {
    die(json_encode(["error" => "Kapcsolati hiba: " . $conn->connect_error]));
}


$sql = "SELECT id, name, body_part, equipment, target FROM exercises LIMIT 50";
$result = $conn->query($sql);

$exercise_data = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $exercise_data[] = $row;
    }
}


$api_url = "https://api.openai.com/v1/chat/completions";

$api_key = "YOUR_OPENAI_API_KEY";

$prompt = "Generate a 1-week structured workout plan for muscle gain suitable for an intermediate-level individual. 

The workout plan must be structured as follows:

{
  \"workout_plan\": [
    {
      \"day\": \"Day 1\",
      \"exercises\": [
        {
          \"exercise_name\": \"example exercise\",
          \"body_part\": \"example body part\",
          \"equipment\": \"example equipment\",
          \"target\": \"example target muscle\",
          \"sets\": 4,
          \"reps\": 10,
          \"weight\": 50,
          \"rest_time\": 60
        }
      ]
    }
  ]
}

Instructions:
- Do not include weeks. Provide workout days (Day 1, Day 2, etc.).
-Adjust **training frequency** based on experience level:
   - Beginner: 3 workouts per week
   - Intermediate: 4-5 workouts per week
   - Advanced: 5-6 workouts per week
- Each \"day\" must contain 2-4 exercises targeting related muscle groups.
- Each day must focus on **related muscle groups**, for example:
   - Day 1: Chest & Triceps
   - Day 2: Back & Biceps
- Provide numerical values only for \"weight\" (integer or float), no percentages or text.
- Provide numerical values only for \"rest_time\" in seconds (e.g., 60, 90), without any text.
- Respond ONLY in valid JSON format as explicitly shown above, without markdown, notes, or explanations.";

// Guzzle HTTP client setup
$client = new Client();

try {
    $response = $client->post($api_url, [
        'headers' => [
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer ' . $api_key
        ],
        'json' => [
            "model" => "gpt-3.5-turbo",
            "messages" => [
                ["role" => "system", "content" => "Respond strictly in valid JSON format as requested."],
                ["role" => "user", "content" => $prompt]
            ],
            "temperature" => 0.7,
            "max_tokens" => 1500
        ]
    ]);

    $response_data = json_decode($response->getBody(), true);
    $ai_response = trim($response_data["choices"][0]["message"]["content"]);

// Remove Markdown formatting or any non-JSON wrappers
$start_pos = strpos($ai_response, '{');
$end_pos = strrpos($ai_response, '}');

if ($start_pos === false || $end_pos === false) {
    die(json_encode(["error" => "AI response does not contain valid JSON!"]));
}

$json_clean = substr($ai_response, $start_pos, ($end_pos - $start_pos + 1));
$workout_plan = json_decode($json_clean, true);

if (json_last_error() !== JSON_ERROR_NONE || !isset($workout_plan["workout_plan"])) {
    die(json_encode(["error" => "AI response JSON decoding failed: " . json_last_error_msg()]));
}


$workout_plan = $workout_plan["workout_plan"];

$values = [];
$user_id = 1;
$exercise_id = null; 


foreach ($workout_plan as $day => $day_data) {
    if (!isset($day_data["exercises"])) continue;

    foreach ($day_data["exercises"] as $exercise) {
        $day_name = $day_data["day"] ?? "Unknown Day";
        $exercise_name = $exercise["exercise_name"] ?? "";
        $body_part = $exercise["body_part"] ?? "";
        $equipment = $exercise["equipment"] ?? "";
        $target = $exercise["target"] ?? "";
        $sets = intval($exercise["sets"] ?? 3);
        $reps = intval($exercise["reps"] ?? 10);
        $weight = isset($exercise["weight"]) && is_numeric($exercise["weight"])? floatval($exercise["weight"]) : 0;
        $rest_time = intval($exercise["rest_time"] ?? 60);
        $exercise_id = $exercise_data[$exercise_name] ?? "NULL";

        foreach ($exercise_data as $db_exercise) {
            if ($db_exercise["name"] === $exercise_name) {
                $exercise_id = $db_exercise["id"];
                break;
            }
        }
    
        // Ha nem találjuk az ID-t, legyen NULL
        if ($exercise_id === null) {
            $exercise_id = "NULL";
        }

        $values[] = "('$user_id', $exercise_id, '{$conn->real_escape_string($day_name)}', '{$conn->real_escape_string($exercise_name)}', '{$conn->real_escape_string($body_part)}', '{$conn->real_escape_string($equipment)}', '{$conn->real_escape_string($target)}', '$sets', '$reps', '$weight', '$rest_time')";

    }
}

if (!empty($values)) {
    $sql_insert = "INSERT INTO personalized_workouts 
    (user_id, exercises_id, day, exercise_name, body_part, equipment, target, sets, reps, weight, rest_time)
    VALUES " . implode(",", $values);

    if ($conn->query($sql_insert)) {
        echo json_encode(["success" => "Workout plan saved!"]);
    } else {
        echo json_encode(["error" => "Database error: " . $conn->error]);
    }
} else {
    echo json_encode(["error" => "No valid workout data found."]);
}

} catch (RequestException $e) {
    echo json_encode(["error" => "API error: " . $e->getMessage()]);
}


echo "<pre>";
print_r($workout_plan);
echo "</pre>";

$conn->close();
exit();
?>