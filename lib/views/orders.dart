import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wozza/configs/colors.dart';
import 'package:wozza/configs/api.dart';
import 'package:wozza/controllers/menucontroller.dart' as wozza_menu;

// --- MODEL ---
class OrderModel {
  final String id;
  final String tableName;
  final List<String> items;
  final String time;
  final double total;
  String status;

  OrderModel({
    required this.id,
    required this.tableName,
    required this.items,
    required this.time,
    required this.total,
    this.status = 'Pending',
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      tableName: json['table_name']?.toString() ?? 'Unknown',
      items: json['items'] is List ? List<String>.from(json['items']) : [],
      time: json['time']?.toString() ?? '',
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'Pending',
    );
  }
}

// --- SCREEN ---
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final wozza_menu.MenuController menuController = Get.put(
    wozza_menu.MenuController(),
  );
  List<OrderModel> orders = [];
  bool isLoading = false;

  static String get baseUrl => '${ApiConfig.baseUrl}/orders.php';

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final serverData = jsonDecode(response.body);
        final List<dynamic> orderData = serverData['data'] ?? [];
        setState(() {
          orders = orderData.map((o) => OrderModel.fromJson(o)).toList();
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection failed');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> submitOrder(
    String tableName,
    List<String> items,
    double total,
  ) async {
    String formattedTable = tableName.trim();
    if (RegExp(r'^\d+$').hasMatch(formattedTable)) {
      formattedTable = "Table $formattedTable";
    }

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'table_name': formattedTable,
          'items': items,
          'status': 'Pending',
          'total': total,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchOrders();
        Get.snackbar('Success', 'Order Created');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save order');
    }
  }

  Future<void> updateOrderStatus(OrderModel order, String newStatus) async {
    try {
      await http.put(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': order.id, 'status': newStatus}),
      );
      fetchOrders();
    } catch (e) {
      Get.snackbar('Error', 'Update failed');
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await http.delete(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id}),
      );
      fetchOrders();
    } catch (e) {
      Get.snackbar('Error', 'Delete failed');
    }
  }

  // --- THE NEW INTERACTIVE DIALOG ---
  void _showNewOrderDialog() {
    final tableController = TextEditingController();
    Map<String, int> selectedItems = {};
    String activeCategory = 'Beer';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            double currentTotal = 0;
            selectedItems.forEach((name, qty) {
              currentTotal += menuController.getPriceByName(name) * qty;
            });

            List<wozza_menu.MenuItem> filteredMenu = menuController.menuList
                .where((item) => item.category == activeCategory)
                .toList();

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              titlePadding: const EdgeInsets.all(0),
              title: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Text(
                    "Create New Order",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      "Add a new order by selecting a table and items from the menu.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Table Number",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: tableController,
                        decoration: InputDecoration(
                          hintText: "e.g., Table 5 or Bar",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Select Items from Menu",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // CATEGORY CHIPS
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              [
                                'Beer',
                                'Cocktails',
                                'Wine',
                                'Spirits',
                                'Food',
                                'Soft Drinks',
                              ].map((cat) {
                                bool isSelected = activeCategory == cat;
                                return GestureDetector(
                                  onTap: () => setDialogState(
                                    () => activeCategory = cat,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      cat,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // MENU LISTING
                      ...filteredMenu.map((item) {
                        int qty = selectedItems[item.itemName] ?? 0;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.itemName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "KES ${item.price.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => setDialogState(() {
                                      if (qty > 0)
                                        selectedItems[item.itemName] = qty - 1;
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text("$qty"),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () => setDialogState(
                                      () => selectedItems[item.itemName] =
                                          qty + 1,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentTotal > 0
                          ? primaryColor.withOpacity(0.6)
                          : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: currentTotal > 0
                        ? () {
                            List<String> itemsToSubmit = [];
                            selectedItems.forEach((name, qty) {
                              if (qty > 0) itemsToSubmit.add("${qty}x $name");
                            });
                            submitOrder(
                              tableController.text,
                              itemsToSubmit,
                              currentTotal,
                            );
                            Navigator.pop(context);
                          }
                        : null,
                    child: Text(
                      "Create Order - KES ${currentTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- MAIN SCREEN BUILD ---
  @override
  Widget build(BuildContext context) {
    final pending = orders.where((o) => o.status == 'Pending').length;
    final preparing = orders.where((o) => o.status == 'Preparing').length;
    final completed = orders.where((o) => o.status == 'Completed').length;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text(
          "Back to Dashboard",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Orders Management",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _showNewOrderDialog,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "New Order",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : RefreshIndicator(
                    onRefresh: fetchOrders,
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        statusCard("Pending Orders", "$pending", primaryColor),
                        statusCard("Preparing", "$preparing", Colors.orange),
                        statusCard("Completed", "$completed", Colors.green),
                        const SizedBox(height: 10),
                        ...orders.map((o) => orderCard(o)),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget statusCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget orderCard(OrderModel order) {
    Color statusColor = order.status == 'Pending'
        ? primaryColor
        : (order.status == 'Preparing' ? Colors.orange : Colors.green);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.tableName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      order.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            order.time,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 15),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                "• $item",
                style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 15),
              ),
            ),
          ),
          const Divider(height: 30),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total: KES",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      order.total.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (order.status != 'Completed')
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: order.status == 'Pending'
                        ? Colors.orange
                        : Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => updateOrderStatus(
                    order,
                    order.status == 'Pending' ? 'Preparing' : 'Completed',
                  ),
                  child: Text(
                    order.status == 'Pending'
                        ? "Start Preparing"
                        : "Finish Order",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              const SizedBox(width: 10),
              if (order.status == 'Pending')
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => updateOrderStatus(order, 'Cancelled'),
                  child: Text("Cancel", style: TextStyle(color: primaryColor)),
                ),
              if (order.status == 'Completed')
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryColor),
                  onPressed: () => deleteOrder(order.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
