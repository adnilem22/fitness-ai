<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

require 'vendor/autoload.php';
use GuzzleHttp\Client;

$servername = "localhost";
$username   = "root";   
$password   = "";   
$dbname     = "sys";    

try {
    $conn = new mysqli($servername, $username, $password, $dbname);
   
    if ($conn->connect_error) {
        throw new Exception("Kapcsolati hiba: " . $conn->connect_error);
    }
    
    
    $conn->set_charset("utf8mb4");
    //azonositas
    $user_id = isset($_GET['user_id']) ? (int)$_GET['user_id'] : null;
    $phone_number = $_GET['phone_number'] ?? null;

    if ($user_id) {
        $user_stmt = $conn->prepare("SELECT id, goal_id, weight, fitness_level_id AS level, gender FROM users WHERE id = ?");
        $user_stmt->bind_param("i", $user_id);
    } elseif ($phone_number) {
        $user_stmt = $conn->prepare("SELECT id, goal_id, weight, fitness_level_id AS level, gender FROM users WHERE phone_number = ?");
        $user_stmt->bind_param("s", $phone_number);
    } else {
        throw new Exception("Missing required parameter: user_id or phone_number");
    }

    $user_stmt->execute();
    $user_res = $user_stmt->get_result();

    if ($user_res->num_rows === 0) {
        throw new Exception("User not found");
    }

    $user = $user_res->fetch_assoc();
    $user_stmt->close();

 
    $user_id = (int)$user['id'];
   
    $fitness_levels = [
        1 => 'Beginner',
        2 => 'Intermediate', 
        3 => 'Advanced'
    ];
    $user['level_text'] = $fitness_levels[$user['level']] ?? 'Beginner';
    
    
    $ex_stmt = $conn->prepare("
        SELECT name, tutorial_url
        FROM exercises 
        WHERE tutorial_url IS NOT NULL AND tutorial_url != ''
        ORDER BY RAND()
        LIMIT 100
    ");
    
    if (!$ex_stmt) {
        throw new Exception("Prepare failed for exercises: " . $conn->error);
    }
    
    $ex_stmt->execute();
    $res_ex = $ex_stmt->get_result();
    
    $exercise_names = [];
    $tutorial_map = []; 
    while($row = $res_ex->fetch_assoc()) {
        $exercise_names[] = $row['name'];
        $tutorial_map[$row['name']] = $row['tutorial_url']; 
        
        error_log("Exercise: " . $row['name'] . " - Tutorial: " . $row['tutorial_url']);
    }
    $ex_stmt->close();
    
    error_log("Found " . count($exercise_names) . " total exercises with tutorial URLs");
    
    if(empty($exercise_names)) {
        throw new Exception("No exercises found in database. Please check your exercises table.");
    }
    
    
    $exercise_list_json = json_encode($exercise_names, JSON_UNESCAPED_UNICODE);
    
    
    $goal_descriptions = [
        1 => 'Weight Loss / Fat Burning',
        2 => 'Muscle Building / Hypertrophy', 
        3 => 'Strength Training',
        4 => 'Endurance / Cardio',
        5 => 'General Fitness'
    ];
    
    
    $goal_description = $goal_descriptions[$user['goal_id']] ?? 'General Fitness';
    
    $prompt = "Choose from the following exercises and generate a 1-week daily workout plan 
    based on the given parameters. Request 3-5 exercises per day:

    Exercise list: $exercise_list_json
    
    User:
    - Goal: {$goal_description} (goal_id: {$user['goal_id']})
    - Weight: {$user['weight']} kg
    - Experience level: {$user['level_text']}
    - Gender: {$user['gender']}
    
    IMPORTANT: 
    - Each day must include at least 3 exercises, preferably 3 to 5 per day.
    - Respond ONLY in plain JSON format.
    - Do NOT wrap your response in markdown or code blocks.
    - Provide a clean JSON response exactly as shown below:
    
    {
      \"workout_plan\": [
        {
          \"day\": \"Day 1\",
          \"exercises\": [
            {
              \"exercise_name\": \"Push-Up\",
              \"body_part\": \"chest\",
              \"equipment\": \"body weight\",
              \"target\": \"pectorals\",
              \"sets\": 4,
              \"reps\": 12,
              \"weight\": 0,
              \"rest_time\": 60,
              \"tutorial_url\": \"https://www.youtube.com/...\"
            }
          ]
        }
      ]
    }
    
    Requirements:
    - Select exercises that match the user's goal: {$goal_description}
    - Day 1 must only use the “Day 1” list (Chest & Triceps exercises).
    - Day 2 only from the “Day 2” list, etc.
    - Beginner: 3 workouts per week, Intermediate: 4-5, Advanced: 5-6
    - Daily target only related muscle groups (e.g. Chest & Triceps, Back & Biceps)
    - \"weight\" and \"rest_time\" only numbers (integers), no other text
    - Use only the provided exercises from the list
    - Choose exercises intelligently based on the goal (e.g., compound movements for strength, high-rep exercises for weight loss, etc.)
    - Do NOT wrap your response in markdown or any formatting, provide raw JSON only.";
    
    
    $api_key = 'YOUR_OPENAI_API_KEY';
    
    $client = new Client([
        'timeout' => 30,
        'verify' => true
    ]);
    
    $response = $client->post('https://api.openai.com/v1/chat/completions', [
        'headers' => [
            'Content-Type'  => 'application/json',
            'Authorization' => 'Bearer ' . $api_key
        ],
        'json' => [
            'model'       => 'gpt-3.5-turbo',
            'messages'    => [
                [
                    'role' => 'system',
                    'content' => 'You are a professional fitness trainer. Respond ONLY in valid JSON format, no explanations or extra text.'
                ],
                [
                    'role' => 'user',
                    'content' => $prompt
                ]
            ],
            'temperature' => 0.7,
            'max_tokens'  => 2000
        ]
    ]);
    
    $response_body = json_decode($response->getBody(), true);
    
    if (!isset($response_body['choices'][0]['message']['content'])) {
        throw new Exception("Invalid API response format");
    }
    
    $content = trim($response_body['choices'][0]['message']['content']);
    
   
    $workout_data = json_decode($content, true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("Failed to parse workout plan JSON: " . json_last_error_msg() . "\nContent: " . $content);
    }
    
    if (!isset($workout_data['workout_plan']) || !is_array($workout_data['workout_plan'])) {
        throw new Exception("Invalid workout plan format in API response");
    }
    
    $plan = $workout_data['workout_plan'];
    
    
    $conn->autocommit(FALSE);
    
    try {
      
        $delete_stmt = $conn->prepare("DELETE FROM personalized_workouts WHERE user_id = ?");
        if (!$delete_stmt) {
            throw new Exception("Prepare failed for delete: " . $conn->error);
        }
        $delete_stmt->bind_param("i", $user_id);
        $delete_stmt->execute();
        $delete_stmt->close();
        
        $insert_stmt = $conn->prepare("
            INSERT INTO personalized_workouts
            (user_id, day, exercise_name, body_part, equipment, target,
             sets, reps, weight, rest_time, tutorial_url)
            VALUES (?,?,?,?,?,?,?,?,?,?,?)"
        );
        if (!$insert_stmt) {
            throw new Exception("Prepare failed for insert: " . $conn->error);
        }

        foreach ($plan as $day_plan) {
            if (!isset($day_plan['day'], $day_plan['exercises'])) {
                throw new Exception("Invalid day plan format");
            }
            $day = $day_plan['day'];

            foreach ($day_plan['exercises'] as $exercise) {
              
                foreach (['exercise_name','body_part','equipment','target','sets','reps','weight','rest_time'] as $f) {
                    if (!isset($exercise[$f])) {
                        throw new Exception("Missing required field: $f");
                    }
                }

            
                $name       = $exercise['exercise_name'];
                $body_part  = $exercise['body_part'];
                $equipment  = $exercise['equipment'];
                $target     = $exercise['target'];
                $sets       = (int)$exercise['sets'];
                $reps       = (int)$exercise['reps'];
                $weight     = (int)$exercise['weight'];
                $rest_time  = (int)$exercise['rest_time'];
               
                
                $tutorial_url = $tutorial_map[$name] ?? null;

                error_log("Saving exercise: $name with tutorial: " . ($tutorial_url ?? 'NULL'));
                    
                $insert_stmt->bind_param(
                    'isssssiiiis', 
                    $user_id,
                    $day,
                    $name,
                    $body_part,
                    $equipment,
                    $target,
                    $sets,
                    $reps,
                    $weight,
                    $rest_time,
                    $tutorial_url
                );

                if (!$insert_stmt->execute()) {
                    throw new Exception("Execute failed: " . $insert_stmt->error);
                }
            }
        }
        
        $insert_stmt->close();
        $conn->commit();
        
       
        $verify_stmt = $conn->prepare("
            SELECT exercise_name, tutorial_url 
            FROM personalized_workouts 
            WHERE user_id = ? 
            LIMIT 5
        ");
        $verify_stmt->bind_param("i", $user_id);
        $verify_stmt->execute();
        $verify_result = $verify_stmt->get_result();
        
        $saved_exercises = [];
        while ($row = $verify_result->fetch_assoc()) {
            $saved_exercises[] = [
                'name' => $row['exercise_name'],
                'tutorial_url' => $row['tutorial_url']
            ];
            error_log("Verified saved: " . $row['exercise_name'] . " - Tutorial: " . ($row['tutorial_url'] ?? 'NULL'));
        }
        $verify_stmt->close();
        
      
        echo json_encode([
            "success" => true,
            "message" => "Workout plan generated and saved successfully!",
            "workout_plan" => $plan,
            "user_info" => [
                "fitness_level" => $user['level_text'],
                "weight" => $user['weight'],
                "gender" => $user['gender'],
                "goal_id" => $user['goal_id']
            ],
            "debug_info" => [
                "exercises_with_tutorials" => count($tutorial_map),
                "saved_exercises_sample" => $saved_exercises
            ]
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        
    } catch (Exception $e) {
        $conn->rollback();
        throw new Exception("Database transaction failed: " . $e->getMessage());
    }
    
} catch (Exception $e) {
   
    http_response_code(400);
    error_log("AI Workout Generation Error: " . $e->getMessage());

    echo json_encode([
        "success" => false,
        "error" => $e->getMessage()
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    
} finally {
    
    if (isset($conn)) {
        $conn->close();
    }
}
?>