<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

$exercise_name = $_GET['exercise_name'] ?? '';

$conn = new mysqli('localhost', 'root', '', 'sys');
$conn->set_charset("utf8mb4");

$stmt = $conn->prepare("SELECT tutorial_url FROM exercises WHERE name = ?");
$stmt->bind_param("s", $exercise_name);
$stmt->execute();

$result = $stmt->get_result();
if ($row = $result->fetch_assoc()) {
    echo json_encode(["success" => true, "tutorial_url" => $row['tutorial_url']]);
} else {
    echo json_encode(["success" => false, "tutorial_url" => ""]);
}
$conn->close();
