<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// Database config
$host = "localhost";
$db = "wozza"; 
$user = "root";       
$pass = "";          

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed"]);
    exit;
}

// Read JSON body (matches your Flutter controller's jsonEncode)
$input = json_decode(file_get_contents("php://input"), true);

$email = isset($input['fullname']) ? trim($input['fullname']) : "";
$pass  = isset($input['password']) ? trim($input['password']) : "";

if (empty($email) || empty($pass)) {
    echo json_encode(["success" => false, "message" => "Email and password are required"]);
    exit;
}

// Use prepared statement to prevent SQL injection
$stmt = $conn->prepare("SELECT id, email FROM users WHERE email = ? AND password = ?");
$stmt->bind_param("ss", $email, $pass);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 1) {
    $user = $result->fetch_assoc();
    echo json_encode([
        "success" => true,
        "message" => "Login successful",
        "user" => [
            "id"    => $user['id'],
            "email" => $user['email']
        ]
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Invalid email or password"]);
}

$stmt->close();
$conn->close();
?>