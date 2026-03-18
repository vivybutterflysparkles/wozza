import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  void _showNewOrderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController orderController = TextEditingController();
        return AlertDialog(
          title: const Text("New Order"),
          content: TextField(
            controller: orderController,
            decoration: const InputDecoration(hintText: "Enter order details"),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle order submission here
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Widget _featureCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.red),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("About BarMetrics"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewOrderDialog,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.red.shade900],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Icon(Icons.wine_bar, color: Colors.red, size: 40),
                  SizedBox(height: 10),
                  Text(
                    "BarMetrics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "A comprehensive bar management system designed to streamline operations, track inventory, manage orders, and monitor employee performance.",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text("Version 1.0.0", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Features",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            _featureCard(
              Icons.inventory,
              "Inventory Management",
              "Track stock levels, manage supplies, and get low stock alerts.",
            ),
            _featureCard(
              Icons.shopping_cart,
              "Order Management",
              "Create and manage customer orders efficiently.",
            ),
            _featureCard(
              Icons.access_time,
              "Time Tracking",
              "Log employee clock-in and clock-out times automatically.",
            ),
            _featureCard(
              Icons.security,
              "Secure Access",
              "Employee authentication and role-based access control.",
            ),
            _featureCard(
              Icons.people,
              "Team Management",
              "Manage multiple staff members and their activities.",
            ),
            _featureCard(
              Icons.local_bar,
              "Bar Focused",
              "Designed specifically for bar and beverage operations.",
            ),

            const SizedBox(height: 20),

            // Contact Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Contact Information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Email: support@barmetrics.com"),
                  Text("Phone: +254 700 123 456"),
                  Text("Address: Nairobi, Kenya"),
                  Divider(height: 20),
                  Text(
                    "© 2026 BarMetrics. All rights reserved.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
