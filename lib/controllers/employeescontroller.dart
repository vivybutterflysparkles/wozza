import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wozza/configs/api.dart'; // Ensure you have this for your IP address

class Employeescontroller extends GetxController {
  var employeesList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // IMPORTANT: Replace localhost with your computer's IPv4 address for real devices
  static final String baseUrl = "${ApiConfig.baseUrl}/employees.php";

  Future<void> fetchEmployees() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final serverData = jsonDecode(response.body);
        final List<dynamic> data = serverData['data'] ?? [];
        employeesList.value = data
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not fetch employees: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addEmployee(String name, String email, String role) async {
    if (name.isEmpty || email.isEmpty || role.isEmpty) {
      Get.snackbar('Validation', 'Please fill all fields');
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "role": role}),
      );
      if (response.statusCode == 200) {
        await fetchEmployees();
        Get.snackbar('Success', 'Employee added');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  Future<void> deleteEmployee(String id) async {
    if (id.isEmpty) return;
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"action": "delete", "id": id}),
      );
      if (response.statusCode == 200) {
        await fetchEmployees();
        Get.snackbar('Success', 'Employee removed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }
}
