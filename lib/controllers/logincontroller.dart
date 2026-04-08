import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Logincontroller extends GetxController {
  // Observables for the UI
  var isPasswordVisible = false.obs;
  var isLoading = false.obs; // To show a spinner while logging in

  // Toggle password visibility
  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Updated Login Function to talk to XAMPP
  Future<bool> login(String user, String pass) async {
    // 1. Basic Validation
    if (user.isEmpty || pass.isEmpty) {
      Get.snackbar("Error", "Please enter both username and password");
      return false;
    }

    isLoading.value = true;

    try {
      // 2. Your API URL
      // Replace 192.168.x.x with your IPv4 address from ipconfig
      var url = Uri.parse("http://localhost/wozza/login.php");

      // 3. Send POST request
      var response = await http.post(
        url,
        body: {"username": user, "password": pass},
      );

      // 4. Handle Response
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['success'] == true) {
          // You can even save user data here if you want
          // e.g., String fullName = data['user']['fullname'];
          return true;
        } else {
          Get.snackbar("Login Failed", data['message']);
          return false;
        }
      } else {
        Get.snackbar("Server Error", "Status Code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Connection Error",
        "Check if XAMPP is running and IP is correct",
      );
      print("Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
