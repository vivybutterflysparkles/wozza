import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:wozza/configs/colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  fetchOrders() async{
    var response = await http.get(Uri.parse("http://localhost/orders/orders.php"));
    if(response.statusCode == 200){

      var serverData = jsonDecode(response.body);
      var OrderData = serverData["data"];
      for(var order in orderData);
      print(response.body);
    }else{
      Get.snackbar("Error","Server error");
    }
  }
  /// 🔥 POPUP
  void _showNewOrderDialog() {
    TextEditingController tableController = TextEditingController();
    TextEditingController itemsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Order"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tableController,
                decoration: const InputDecoration(labelText: "Table Number"),
              ),
              TextField(
                controller: itemsController,
                decoration: const InputDecoration(
                  labelText: "Items (comma separated)",
                ),
              ),
            ],
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

  /// 🔥 SAME SIZE STATUS CARD (COLUMN VERSION)
  Widget statusCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      height: 100, // 🔥 FIXED HEIGHT (KEY FIX)
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 5)),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// 🔥 ORDER CARD
  Widget orderCard() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Table 5",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Pending",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),
          const Text("14:30", style: TextStyle(color: Colors.grey)),

          const SizedBox(height: 10),

          const Text("• 2x Beer - Lager"),
          const Text("• 1x Whiskey Sour"),
          const Text("• 1x Nachos"),

          const Divider(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total: KES 2600.00"),

              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: (){},
                    child: const Text("Start Preparing"),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(onPressed: () {}, child: const Text("Cancel")),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index){
        return Row(children: [
          Image.asset("assets/logo.jpeg",width: 100,height: 100),
          Column(children: [Text(tableNames[index]), Text(itemNames[index])
          ],)
        ],)
      },
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back),
        title: const Text("Back to Dashboard"),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔥 HEADER
            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.all(20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Orders",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Management",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: _showNewOrderDialog,
                    child: const Text("+ New Order"),
                  ),
                ],
              ),
            ),

            /// 🔥 BODY
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// 🔥 STACKED BUT SAME SIZE
                  statusCard("Pending Orders", "1", Colors.red),
                  statusCard("Preparing", "2", Colors.orange),
                  statusCard("Completed", "0", Colors.green),

                  /// Orders
                  orderCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
