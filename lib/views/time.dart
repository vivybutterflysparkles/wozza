import 'package:flutter/material.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  /// 🔥 OPTIONAL POPUP (ADD SHIFT)
  void _showAddShiftDialog() {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Shift"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Employee Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  /// 🔥 ACTIVE SHIFT CARD
  Widget activeShiftCard(String name, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: Colors.green, width: 5)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 5),

              Row(
                children: const [
                  Icon(Icons.calendar_today, size: 14),
                  SizedBox(width: 5),
                  Text("2026-01-04"),
                ],
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  const Icon(Icons.play_arrow, size: 16, color: Colors.green),
                  const SizedBox(width: 5),
                  Text("Clocked in at $time"),
                ],
              ),
            ],
          ),

          /// BUTTON
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {},
            child: const Text("Clock Out"),
          ),
        ],
      ),
    );
  }

  /// 🔥 COMPLETED SHIFT CARD
  Widget completedShiftCard(String name, String hours, String timeRange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: Colors.black, width: 5)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 5),

              Row(
                children: const [
                  Icon(Icons.calendar_today, size: 14),
                  SizedBox(width: 5),
                  Text("2026-01-04"),
                ],
              ),

              const SizedBox(height: 5),

              Text(timeRange),
            ],
          ),

          /// RIGHT
          Column(
            children: [
              Text(
                hours,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Total Hours",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// 🔥 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back),
        title: const Text("Back to Dashboard"),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 HEADER
            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.all(20),

              child: const Text(
                "Employee Time Tracking",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// 🔥 CONTENT
            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ACTIVE
                  const Text(
                    "Active Shifts",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  activeShiftCard("John Smith", "09:00"),
                  activeShiftCard("Sarah Johnson", "10:00"),

                  const SizedBox(height: 20),

                  /// COMPLETED
                  const Text(
                    "Completed Shifts",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  completedShiftCard("Mike Davis", "8h", "08:00 - 16:00"),
                  completedShiftCard("Emily Wilson", "8h", "14:00 - 22:00"),
                ],
              ),
            ),
          ],
        ),
      ),

      /// 🔥 FLOATING BUTTON (OPTIONAL ADD SHIFT)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _showAddShiftDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
