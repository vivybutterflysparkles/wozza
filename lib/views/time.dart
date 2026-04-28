import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wozza/configs/colors.dart';
import 'package:wozza/controllers/timecontroller.dart';
import 'package:wozza/controllers/employeescontroller.dart'; // IMPORTED THIS

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});
  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  final TimeController controller = Get.put(TimeController());
  // Access the employees already in memory
  final Employeescontroller empController = Get.put(Employeescontroller());

  void _showAddShiftDialog() {
    String? selectedEmployee;
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    // Ensure we have fresh employee data
    empController.fetchEmployees();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              "New Shift Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Employee",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 5),

                // DROPDOWN LINKED TO EMPLOYEES
                Obx(() {
                  if (empController.isLoading.value) {
                    return const LinearProgressIndicator();
                  }
                  if (empController.employeesList.isEmpty) {
                    return const Text(
                      "No staff found in Employee Hub",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    hint: const Text("Choose Staff"),
                    value: selectedEmployee,
                    items: empController.employeesList.map((emp) {
                      return DropdownMenuItem<String>(
                        value: emp['name'].toString(),
                        child: Text(emp['name'].toString()),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setDialogState(() => selectedEmployee = val),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Shift Date:"),
                    TextButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2025),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null)
                          setDialogState(() => selectedDate = picked);
                      },
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Clock In Time:"),
                    TextButton(
                      onPressed: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null)
                          setDialogState(() => selectedTime = picked);
                      },
                      child: Text(selectedTime.format(context)),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () {
                  if (selectedEmployee != null) {
                    String formattedTime =
                        "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00";
                    String formattedDate = DateFormat(
                      'yyyy-MM-dd',
                    ).format(selectedDate);

                    controller.clockIn(
                      selectedEmployee!,
                      formattedDate,
                      formattedTime,
                    );
                    Get.back();
                  } else {
                    Get.snackbar(
                      "Required",
                      "Please select an employee",
                      backgroundColor: Colors.orange,
                    );
                  }
                },
                child: const Text(
                  "Start Shift",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  const Text(
                    "Time Tracking",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: _showAddShiftDialog,
                    child: const Text(
                      "Add Shift",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value)
                  return const Center(child: CircularProgressIndicator());
                var active = controller.shifts
                    .where((s) => s.status == 'active')
                    .toList();
                var completed = controller.shifts
                    .where((s) => s.status == 'completed')
                    .toList();
                return RefreshIndicator(
                  onRefresh: () => controller.fetchShifts(),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text(
                        "Active Shifts",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...active.map((s) => _buildShiftCard(s, true)),
                      const SizedBox(height: 30),
                      const Text(
                        "History",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...completed.map((s) => _buildShiftCard(s, false)),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftCard(ShiftModel shift, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: isActive ? Colors.green : Colors.black,
            width: 6,
          ),
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shift.employeeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Date: ${shift.date}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  isActive
                      ? "In: ${shift.clockIn}"
                      : "Time: ${shift.clockIn} - ${shift.clockOut}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          isActive
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => controller.clockOut(shift.id),
                  child: const Text(
                    "Clock Out",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          shift.totalHours ?? "0.00",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Text(
                          "Hours",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.grey,
                      ),
                      onPressed: () => controller.deleteShift(shift.id),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
