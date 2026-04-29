<?php
// 1. Setup Headers
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// 2. Suppress HTML error reporting to prevent "Unexpected token <" in Flutter
error_reporting(0);
ini_set('display_errors', 0);

// 3. Database connection
$host = "localhost";
$user = "root";
$pass = "";
$db   = "wozza"; 

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed"]);
    exit;
}

// 4. Capture Data (Handles both Flutter JSON and Postman Form-Data)
$json = file_get_contents('php://input');
$data = json_decode($json, true);

if ($data) {
    // Data from Flutter
    $fullname = $data['fullname'] ?? '';
    $email    = $data['email'] ?? '';
    $password = $data['password'] ?? '';
} else {
    // Data from Postman/Web Form
    $fullname = $_POST['fullname'] ?? '';
    $email    = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
}

// 5. Validation
if (empty($fullname) || empty($email) || empty($password)) {
    echo json_encode(["success" => false, "message" => "Required fields are missing"]);
    exit;
}

// 6. Check if user already exists
$sql_check = "SELECT * FROM users WHERE email='$email'";
$result = $conn->query($sql_check);

if ($result->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "User already exists"]);
} else {
    // 7. Insert new user 
    // We use 'fullname' to match the table column we created earlier
    $sql = "INSERT INTO users (fullname, email, password) VALUES ('$fullname', '$email', '$password')";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["success" => true, "message" => "Registration successful"]);
    } else {
        echo json_encode(["success" => false, "message" => "Database error: " . $conn->error]);
    }
}

$conn->close();
?>