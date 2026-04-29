<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli("localhost", "root", "", "wozza");

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "DB Error"]);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        $sql = "SELECT id, employee_name, date, clock_in, clock_out, total_hours, status FROM time_tracking ORDER BY id DESC";
        $result = $conn->query($sql);
        $data = [];
        while($row = $result->fetch_assoc()) { $data[] = $row; }
        echo json_encode(["success" => true, "data" => $data]);
        break;

    case 'POST':
        $input = json_decode(file_get_contents("php://input"), true);
        $name = $conn->real_escape_string($input['employee_name']);
        $date = !empty($input['date']) ? $input['date'] : date('Y-m-d');
        $time = !empty($input['clock_in']) ? $input['clock_in'] : date('H:i:s');
        $sql = "INSERT INTO time_tracking (employee_name, date, clock_in, status) VALUES ('$name', '$date', '$time', 'active')";
        if($conn->query($sql)) echo json_encode(["success" => true]);
        break;

    case 'PUT':
        $input = json_decode(file_get_contents("php://input"), true);
        $id = (int)$input['id'];
        $sql = "UPDATE time_tracking SET clock_out = CURTIME(), status = 'completed', total_hours = ROUND(TIME_TO_SEC(TIMEDIFF(CURTIME(), clock_in)) / 3600, 2) WHERE id = $id";
        if($conn->query($sql)) echo json_encode(["success" => true]);
        break;

    case 'DELETE':
        $input = json_decode(file_get_contents("php://input"), true);
        $id = (int)$input['id'];
        $sql = "DELETE FROM time_tracking WHERE id = $id";
        if($conn->query($sql)) {
            echo json_encode(["success" => true]);
        } else {
            echo json_encode(["success" => false, "error" => $conn->error]);
        }
        break;
}
$conn->close();
?>