import 'package:flutter/material.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final List<Map<String, String>> employees = [
    {
      "name": "John Smith",
      "email": "john@barmetrics.com",
      "role": "Bartender",
      "date": "2024-01-15",
    },
    {
      "name": "Sarah Johnson",
      "email": "sarah@barmetrics.com",
      "role": "Server",
      "date": "2024-03-20",
    },
    {
      "name": "Mike Davis",
      "email": "mike@barmetrics.com",
      "role": "Manager",
      "date": "2023-11-10",
    },
  ];

  void showAddEmployeeDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Employee"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(labelText: "Role"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  employees.add({
                    "name": nameController.text,
                    "email": emailController.text,
                    "role": roleController.text,
                    "date": DateTime.now().toString().split(
                      " ",
                    )[0], // yyyy-mm-dd
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget employeeCard(Map<String, String> emp, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          emp["name"]!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.email, size: 16),
                const SizedBox(width: 6),
                Text(emp["email"]!),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.work, size: 16),
                const SizedBox(width: 6),
                Text(emp["role"]!),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 6),
                Text("Joined: ${emp["date"]!}"),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              employees.removeAt(index);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text("Employee Management"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: showAddEmployeeDialog,
              icon: const Icon(Icons.add),
              label: const Text("Add Employee"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Total Employees Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: const Border(
                  left: BorderSide(color: Colors.red, width: 4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Employees",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    employees.length.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Employee List
            Expanded(
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  return employeeCard(employees[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
