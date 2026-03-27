import 'package:get/state_manager.dart';

class Employeescontroller extends GetxController {
  var username = '';
  var email = '';
  var role = '';
  employees(user, email, role) {
    username = user;
    email = email;
    role = role;
    if (username == "" && email == "" && role == "") {
      return true;
    } else {
      return false;
    }
  }
}
