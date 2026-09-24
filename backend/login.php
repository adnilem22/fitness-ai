<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

file_put_contents("debug_login.txt", print_r($_SERVER, true));

$host = "localhost";
$user = "root";
$password = "";
$database = "sys";

$conn = new mysqli($host, $user, $password, $database);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $phone = $_POST['phone_number'];
    $inputPassword = $_POST['password'];

    $stmt = $conn->prepare("SELECT * FROM users WHERE phone_number = ?");
    $stmt->bind_param("s", $phone);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
       
       if (password_verify($inputPassword, $row['password'])) {
    header('Content-Type: application/json');
    echo json_encode([
        "status" => "success",
        "id" => $row['id'],
        "name" => $row['name'],
        "birth_date" => $row['birth_date'],
        "phone_number" => $row['phone_number'],
        "password" => $row['password'],
        "gender" => $row['gender'],
        "fitness_level_id" => $row['fitness_level_id'],
        "goal_id" => $row['goal_id'],
        "height" => $row['height'],
        "weight" => $row['weight']
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Hibas jelszo",
        "debug_input_password" => $inputPassword,
        "stored_password_hash" => $row['password']
    ]);
}
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(["status" => "error", "message" => "Ervenytelen keres"]);
}
?>
