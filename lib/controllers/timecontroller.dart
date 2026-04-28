import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wozza/configs/api.dart';

class ShiftModel {
  final String id;
  final String employeeName;
  final String date;
  final String clockIn;
  final String? clockOut;
  final String? totalHours;
  final String status;

  ShiftModel({
    required this.id,
    required this.employeeName,
    required this.date,
    required this.clockIn,
    this.clockOut,
    this.totalHours,
    required this.status,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'].toString(),
      employeeName: json['employee_name'] ?? '',
      date: json['date'] ?? '',
      clockIn: json['clock_in'] ?? '',
      clockOut: json['clock_out'],
      totalHours: json['total_hours']?.toString(),
      status: json['status'] ?? 'active',
    );
  }
}

class TimeController extends GetxController {
  var shifts = <ShiftModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShifts();
  }

  Future<void> fetchShifts() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/time.php"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          var list = (data['data'] as List)
              .map((s) => ShiftModel.fromJson(s))
              .toList();
          shifts.assignAll(list);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clockIn(String name, String date, String time) async {
    try {
      await http.post(
        Uri.parse("${ApiConfig.baseUrl}/time.php"),
        body: jsonEncode({
          "employee_name": name,
          "date": date,
          "clock_in": time,
        }),
      );
      fetchShifts();
    } catch (e) {
      Get.snackbar("Error", "Clock in failed");
    }
  }

  Future<void> clockOut(String id) async {
    try {
      await http.put(
        Uri.parse("${ApiConfig.baseUrl}/time.php"),
        body: jsonEncode({"id": id}),
      );
      fetchShifts();
    } catch (e) {
      Get.snackbar("Error", "Clock out failed");
    }
  }

  Future<void> deleteShift(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("${ApiConfig.baseUrl}/time.php"),
        body: jsonEncode({"id": id}),
      );
      if (response.statusCode == 200) {
        fetchShifts();
        Get.snackbar("Success", "Shift record deleted");
      }
    } catch (e) {
      Get.snackbar("Error", "Delete failed");
    }
  }
}
