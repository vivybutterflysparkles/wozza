import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wozza/configs/api.dart';

class Signupcontroller extends GetxController {
  // Observables
  var isPasswordVisible = false.obs;
  var isLoading = false.obs; // To track if the request is in progress

  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Updated Signup Function
  Future<bool> signup(
    String user,
    String pass,
    String conf,
    String email,
  ) async {
    // 1. Basic Local Validation
    if (user.isEmpty || email.isEmpty || pass.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return false;
    }

    if (pass != conf) {
      Get.snackbar("Error", "Passwords do not match");
      return false;
    }

    isLoading.value = true;

    try {
      // 2. Your API URL
      var url = Uri.parse("${ApiConfig.baseUrl}/signup.php");

      // 3. Send POST request to PHP
      var response = await http.post(
        url,
        body: {"fullname": user, "email": email, "password": pass},
      );

      // 4. Handle Response from Server
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['success'] == true) {
          Get.snackbar("Success", "Account created successfully!");
          return true;
        } else {
          Get.snackbar("Registration Failed", data['message']);
          return false;
        }
      } else {
        Get.snackbar("Server Error", "Status Code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Connection Error",
        "Ensure XAMPP is running and IP is correct",
      );
      print("Signup Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
