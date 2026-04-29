<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli("localhost", "root", "", "wozza");

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Connection failed"]);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];
$data = json_decode(file_get_contents("php://input"), true);

switch ($method) {
    case 'GET':
        $sql = "SELECT * FROM menu ORDER BY category, item_name ASC";
        $result = $conn->query($sql);
        $items = [];
        while ($row = $result->fetch_assoc()) {
            $items[] = $row;
        }
        echo json_encode(["success" => true, "data" => $items]);
        break;

    case 'POST':
        $name = $data['item_name'];
        $price = $data['price'];
        $category = $data['category'];
        $sql = "INSERT INTO menu (item_name, price, category) VALUES ('$name', '$price', '$category')";
        if ($conn->query($sql)) echo json_encode(["success" => true]);
        break;

    case 'DELETE':
        $id = $data['id'];
        $sql = "DELETE FROM menu WHERE id = '$id'";
        if ($conn->query($sql)) echo json_encode(["success" => true]);
        break;
}
$conn->close();
?>