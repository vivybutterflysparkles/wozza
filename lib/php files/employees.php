<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli("localhost", "root", "", "wozza");

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Connection failed"]);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];

// Handle GET (Fetch)
if ($method == 'GET') {
    $sql = "SELECT * FROM employees ORDER BY id DESC";
    $result = $conn->query($sql);
    $employees = [];
    while ($row = $result->fetch_assoc()) {
        $employees[] = $row;
    }
    echo json_encode(["success" => true, "data" => $employees]);
    exit;
}

// Handle POST (Add & Delete)
if ($method == 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);
    
    // Check if it's a delete action or a standard add
    $action = $data['action'] ?? $_POST['action'] ?? '';

    if ($action == 'delete') {
        $id = $data['id'] ?? $_POST['id'];
        $sql = "DELETE FROM employees WHERE id = $id";
        if ($conn->query($sql)) {
            echo json_encode(["success" => true, "message" => "Employee removed"]);
        }
    } else {
        // Standard Add logic
        $name = $data['name'] ?? $_POST['name'];
        $email = $data['email'] ?? $_POST['email'];
        $role = $data['role'] ?? $_POST['role'];
        $date = date('Y-m-d'); // Auto-generate current date

        $sql = "INSERT INTO employees (name, email, role, date) VALUES ('$name', '$email', '$role', '$date')";
        if ($conn->query($sql)) {
            echo json_encode(["success" => true, "message" => "Employee added"]);
        } else {
            echo json_encode(["success" => false, "message" => "Email already exists or DB error"]);
        }
    }
    exit;
}

$conn->close();
?>