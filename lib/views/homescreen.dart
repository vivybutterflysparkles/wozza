import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:wozza/configs/colors.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  /// DASHBOARD CARD
  Widget dashboardCard({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Container(
      width: double.infinity, // fills screen width
      height: 180,
      margin: const EdgeInsets.only(bottom: 20),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),

        child: Stack(
          children: [
            /// IMAGE BACKGROUND
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, // ensures image fills card
              ),
            ),

            /// DARK OVERLAY
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.45)),
            ),

            /// TEXT
            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// TOP BAR
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: const [
            Icon(Icons.wine_bar, color: primaryColor),
            SizedBox(width: 10),
            Text(
              "BarMetrics",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      /// BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Control Centre",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const Text(
                "Monitor and manage your bar operations",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 10),

              dashboardCard(
                title: "Inventory",
                subtitle: "Manage bar stock and supplies",
                imagePath: "assets/inventory.jpg",
              ),

              dashboardCard(
                title: "Orders",
                subtitle: "Track customer orders",
                imagePath: "assets/orders.jpg",
              ),

              dashboardCard(
                title: "Time Tracking",
                subtitle: "Log employee hours",
                imagePath: "assets/time.jpg",
              ),

              dashboardCard(
                title: "Employees",
                subtitle: "Manage staff and roles",
                imagePath: "assets/employees.jpg",
              ),

              dashboardCard(
                title: "About",
                subtitle: "App information",
                imagePath: "assets/about.jpg",
              ),
            ],
          ),
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: primaryColor,
        buttonBackgroundColor: Colors.white,

        items: const [
          Icon(Icons.dashboard, size: 30),
          Icon(Icons.category, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.person, size: 30),
        ],

        onTap: (index) {},
      ),
    );
  }
}
