import 'package:flutter/material.dart';
import 'package:wozza/configs/colors.dart';
import 'package:wozza/views/about.dart';
import 'package:wozza/views/employees.dart';
import 'package:wozza/views/inventory.dart';
import 'package:wozza/views/orders.dart';
import 'package:wozza/views/profile.dart';
import 'package:wozza/views/time.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0;

  /// 🔥 DASHBOARD CARD
  Widget dashboardCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required IconData icon,
    required Widget page,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: SizedBox(
            width: double.infinity,
            height: 180,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.45)),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: Colors.white, size: 30),
                      const SizedBox(height: 8),
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
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 DASHBOARD SCREEN
  Widget dashboardScreen() {
    return SingleChildScrollView(
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
            const SizedBox(height: 20),

            dashboardCard(
              title: "Inventory",
              subtitle: "Manage bar stock",
              imagePath: "assets/inventory.jpg",
              icon: Icons.inventory,
              page: const InventoryScreen(),
            ),

            dashboardCard(
              title: "Orders",
              subtitle: "Track orders",
              imagePath: "assets/orders.jpg",
              icon: Icons.receipt_long,
              page: const OrdersScreen(),
            ),

            dashboardCard(
              title: "Time Tracking",
              subtitle: "Log hours",
              imagePath: "assets/time.jpg",
              icon: Icons.access_time,
              page: const TimeScreen(),
            ),

            dashboardCard(
              title: "Employees",
              subtitle: "Manage staff",
              imagePath: "assets/employees.jpg",
              icon: Icons.people,
              page: const EmployeesScreen(), // ✅ ONLY here
            ),

            dashboardCard(
              title: "About",
              subtitle: "App info",
              imagePath: "assets/about.jpg",
              icon: Icons.info,
              page: const AboutScreen(),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 BOTTOM NAV PAGES (ONLY 4!)
  final List<Widget> _pages = const [
    SizedBox(), // placeholder for dashboard (handled separately)
    OrdersScreen(),
    TimeScreen(),
    ProfileScreen(), // ✅ Profile here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🔥 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: const [
            Icon(Icons.wine_bar, color: primaryColor),
            SizedBox(width: 10),
            Text("BarMetrics", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),

      /// 🔥 BODY SWITCH
      body: _currentIndex == 0
          ? dashboardScreen() // ✅ Home handled separately
          : _pages[_currentIndex],

      /// 🔥 BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Orders",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Time"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
