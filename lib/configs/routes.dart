import 'package:get/get.dart';
import 'package:wozza/views/homescreen.dart';
import 'package:wozza/views/login.dart';
import 'package:wozza/views/signup.dart';

var routes = [
  GetPage(name: "/login", page: () => LoginScreen()),
  GetPage(name: "/signup", page: () => SignupScreen()),
  GetPage(name: "/homescreen", page: () => Homescreen()),
];
