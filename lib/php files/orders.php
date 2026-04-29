<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

// Database connection to 'wozza'
$conn = new mysqli("localhost", "root", "", "wozza");

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed"]);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];
$json = file_get_contents('php://input');
$data = json_decode($json, true);

switch ($method) {
    // 1. FETCH ALL ORDERS
    case 'GET':
        $sql = "SELECT * FROM orders ORDER BY id DESC";
        $result = $conn->query($sql);
        $orders = [];

        while ($row = $result->fetch_assoc()) {
            // Decode items string back to a list for Flutter
            $row['items'] = json_decode($row['items']); 
            $orders[] = $row;
        }
        echo json_encode(["success" => true, "data" => $orders]);
        break;

    // 2. ADD NEW ORDER
    case 'POST':
        $table_name = $data['table_name'];
        $items = json_encode($data['items']); 
        $status = $data['status'] ?? 'Pending';
        $total = $data['total'] ?? 0.00;

        $sql = "INSERT INTO orders (table_name, items, status, total) 
                VALUES ('$table_name', '$items', '$status', '$total')";

        if ($conn->query($sql) === TRUE) {
            echo json_encode(["success" => true, "message" => "Order created"]);
        } else {
            echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
        }
        break;

    // 3. UPDATE ORDER STATUS
    case 'PUT':
        $id = $data['id'];
        $status = $data['status'];
        $sql = "UPDATE orders SET status = '$status' WHERE id = '$id'";

        if ($conn->query($sql) === TRUE) {
            echo json_encode(["success" => true, "message" => "Status updated"]);
        } else {
            echo json_encode(["success" => false, "message" => "Update failed"]);
        }
        break;

    // 4. DELETE ORDER
    case 'DELETE':
        $id = $data['id'];
        $sql = "DELETE FROM orders WHERE id = '$id'";

        if ($conn->query($sql) === TRUE) {
            echo json_encode(["success" => true, "message" => "Order deleted"]);
        } else {
            echo json_encode(["success" => false, "message" => "Delete failed"]);
        }
        break;
}

$conn->close();
?>