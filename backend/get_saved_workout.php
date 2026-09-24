<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$host = "localhost";
$user = "root";
$pass = "";
$db   = "sys";

$conn = new mysqli($host, $user, $pass, $db);
$conn->set_charset("utf8mb4");

$user_id = $_GET['user_id'] ?? null;
if (!$user_id || !is_numeric($user_id)) {
    echo json_encode(["success" => false, "error" => "Missing or invalid user_id"]);
    exit;
}

$query = "SELECT * FROM personalized_workouts WHERE user_id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$plan = [];
while ($row = $result->fetch_assoc()) {
    $plan[] = [
        "exercise_name" => $row['exercise_name'],
        "body_part"     => $row['body_part'],
        "equipment"     => $row['equipment'],
        "target"        => $row['target'],
        "sets"          => (int)$row['sets'],
        "reps"          => (int)$row['reps'],
        "weight"        => (int)$row['weight'],
        "rest_time"     => (int)$row['rest_time'],
        "day"           => $row['day']
    ];
}

echo json_encode(["success" => true, "workout_plan" => $plan], JSON_UNESCAPED_UNICODE);
$conn->close();
?>
