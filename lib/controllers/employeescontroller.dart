import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Employeescontroller extends GetxController {
  var employeesList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  static const String baseUrl = 'http://localhost/wozza/employees.php';

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
      } else {
        Get.snackbar('Error', 'Server error (${response.statusCode})');
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
        body: {"name": name, "email": email, "role": role},
      );
      if (response.statusCode == 200) {
        await fetchEmployees();
        Get.snackbar('Success', 'Employee added');
      } else {
        Get.snackbar('Error', 'Failed to add employee');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {"action": "delete", "id": id},
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
