import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wozza/configs/api.dart';

class Logincontroller extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<bool> login(String user, String pass) async {
    if (user.isEmpty || pass.isEmpty) {
      Get.snackbar("Error", "Please enter both email and password");
      return false;
    }

    isLoading.value = true;

    try {
      var url = Uri.parse("${ApiConfig.baseUrl}/login.php");

      // We use jsonEncode to ensure PHP's file_get_contents can read it
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"fullname": user, "password": pass}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['success'] == true) {
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
        "Ensure XAMPP is running and IP is correct",
      );
      print("Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
