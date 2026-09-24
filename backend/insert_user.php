<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");


if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo "Only POST requests are allowed.";
    exit;
}


$host = "localhost";
$user = "root";
$password = ""; 
$database = "sys"; 

$conn = new mysqli($host, $user, $password, $database);


if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}


function getPost($key) {
    return isset($_POST[$key]) ? $_POST[$key] : '';
}

$name = getPost('name');
$birth_date = getPost('birth_date');
$phone_number = getPost('phone_number');
$password = getPost('password');
$gender = getPost('gender');
$fitness_level_id = getPost('fitness_level_id');
$goal_id = getPost('goal_id');
$height = getPost('height');
$weight = getPost('weight');


if (empty($name) || empty($birth_date) || empty($phone_number) || empty($password)) {
    echo "Hianyzo kotelezo mezo!";
    exit;
}

if (strlen($password) < 6) {
    echo json_encode(["status" => "error", "message" => "A jelszonak legalabb 6 karakter hosszunak kell lennie."]);
    exit;
}

$password = password_hash($password, PASSWORD_DEFAULT);


$sql = "INSERT INTO users (name, birth_date, phone_number, password, gender, fitness_level_id, goal_id, height, weight)
        VALUES (?, ?, ?, ?,  ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param("sssssiiii", $name, $birth_date, $phone_number, $password, $gender, $fitness_level_id, $goal_id, $height, $weight);

if ($stmt->execute()) {
     $new_user_id = $conn->insert_id;
    header('Content-Type: application/json');
    echo json_encode([
        "id" => $new_user_id, 
        "name" => $name,
        "birth_date" => $birth_date,
        "phone_number" => $phone_number,
        "password" => $password,
        "gender" => $gender,
        "fitness_level_id" => $fitness_level_id,
        "goal_id" => $goal_id,
        "height" => $height,
        "weight" => $weight
    ]);
}
 else {
    echo "error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>
