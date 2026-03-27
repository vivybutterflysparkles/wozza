import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Signupcontroller extends GetxController {
  var username = '';
  var password = '';
  var email = '';
  var confirmPassword = '';
  var isPasswordVisible = false.obs;
  signup(user, pass, conf, email) {
    username = user;
    email = email;
    password = pass;
    confirmPassword = conf;

    if (username == "admin" &&
        password == "12345" &&
        confirmPassword == "12345" &&
        email == "admin@gmail.com") {
      return true;
    } else {
      return false;
    }
  }

  togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
