import 'package:get/get.dart';
import 'package:wozza/views/about.dart';
import 'package:wozza/views/employees.dart';
import 'package:wozza/views/homescreen.dart';
import 'package:wozza/views/inventory.dart';
import 'package:wozza/views/login.dart';
import 'package:wozza/views/orders.dart';
import 'package:wozza/views/profile.dart';
import 'package:wozza/views/signup.dart';
import 'package:wozza/views/time.dart';

var routes = [
  GetPage(name: "/login", page: () => LoginScreen()),
  GetPage(name: "/signup", page: () => SignupScreen()),
  GetPage(name: "/homescreen", page: () => Homescreen()),
  GetPage(name: "/inventory", page: () => InventoryScreen()),
  GetPage(name: "/orders", page: () => OrdersScreen()),
  GetPage(name: "/employees", page: () => EmployeesScreen()),
  GetPage(name: "/time", page: () => TimeScreen()),
  GetPage(name: "/about", page: () => AboutScreen()),
  GetPage(name: "/profile", page: () => ProfileScreen()),
];
