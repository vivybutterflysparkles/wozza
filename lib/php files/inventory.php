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

// Handle GET Request (Fetching)
if ($method == 'GET') {
    $sql = "SELECT * FROM inventory ORDER BY category ASC";
    $result = $conn->query($sql);
    $items = [];
    while ($row = $result->fetch_assoc()) {
        $items[] = $row;
    }
    echo json_encode(["success" => true, "data" => $items]);
    exit;
}

// Handle POST Request (Adding & Updating)
if ($method == 'POST') {
    // Check if data is JSON or Form-Data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);
    
    // If not JSON, use standard $_POST
    $action = $data['action'] ?? $_POST['action'] ?? '';

    if ($action == 'add') {
        $name = $data['name'] ?? $_POST['name'];
        $category = $data['category'] ?? $_POST['category'];
        $quantity = $data['quantity'] ?? $_POST['quantity'];

        $sql = "INSERT INTO inventory (name, category, quantity) VALUES ('$name', '$category', '$quantity')";
        if ($conn->query($sql)) {
            echo json_encode(["success" => true, "message" => "Item added"]);
        }
    } 
    elseif ($action == 'update') {
        $id = $data['id'] ?? $_POST['id'];
        $quantity = $data['quantity'] ?? $_POST['quantity'];

        $sql = "UPDATE inventory SET quantity = '$quantity' WHERE id = '$id'";
        if ($conn->query($sql)) {
            echo json_encode(["success" => true, "message" => "Stock updated"]);
        }
    }
    exit;
}

$conn->close();
?>