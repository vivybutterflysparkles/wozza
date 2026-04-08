import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wozza/configs/colors.dart';

//  Model

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
      items: List<String>.from(json['items'] ?? []),
      time: json['time']?.toString() ?? '',
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'Pending',
    );
  }
}

//  Screen

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderModel> orders = [];
  bool isLoading = false;

  // FIX 1: Use 10.0.2.2 for Android emulator, or your LAN IP for a real device.
  // Change this to your actual server address.
  static const String baseUrl = 'http://10.0.2.2/orders/orders.php';

  // FIX 2: fetchOrders() is now called from initState.
  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  // FIX 3: Variable naming is consistent (lowercase orderData).
  // FIX 4: for-loop body is no longer empty — orders are stored in state.
  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final serverData = jsonDecode(response.body);
        final List<dynamic> orderData = serverData['data'] ?? [];
        final List<OrderModel> fetched = [];
        for (var order in orderData) {
          fetched.add(OrderModel.fromJson(order));
        }
        setState(() => orders = fetched);
      } else {
        Get.snackbar('Error', 'Server error (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not connect: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  //  Submit actually sends data to the server.
  Future<void> submitOrder(String tableName, String itemsRaw) async {
    if (tableName.isEmpty || itemsRaw.isEmpty) {
      Get.snackbar('Validation', 'Please fill in all fields');
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'table_name': tableName,
          'items': itemsRaw.split(',').map((e) => e.trim()).toList(),
          'status': 'Pending',
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchOrders(); // refresh the list
        Get.snackbar('Success', 'Order added');
      } else {
        Get.snackbar('Error', 'Could not save order');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  Future<void> updateOrderStatus(OrderModel order, String newStatus) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': order.id, 'status': newStatus}),
      );
      if (response.statusCode == 200) {
        setState(() => order.status = newStatus);
      } else {
        Get.snackbar('Error', 'Could not update status');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  //  New Order Dialog

  void _showNewOrderDialog() {
    final tableController = TextEditingController();
    final itemsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tableController,
                decoration: const InputDecoration(labelText: 'Table Number'),
              ),
              TextField(
                controller: itemsController,
                decoration: const InputDecoration(
                  labelText: 'Items (comma separated)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              //  "Add" now actually submits the order.
              onPressed: () {
                Navigator.pop(context);
                submitOrder(tableController.text, itemsController.text);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  //  Status Summary Cards

  Widget statusCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      height: 100,
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

  //  Order Card

  //  orderCard() now accepts an OrderModel instead of hardcoded text.
  Widget orderCard(OrderModel order) {
    Color statusColor;
    String nextStatus;
    String actionLabel;

    switch (order.status) {
      case 'Pending':
        statusColor = Colors.red;
        nextStatus = 'Preparing';
        actionLabel = 'Start Preparing';
        break;
      case 'Preparing':
        statusColor = Colors.orange;
        nextStatus = 'Completed';
        actionLabel = 'Mark Complete';
        break;
      default:
        statusColor = Colors.green;
        nextStatus = 'Completed';
        actionLabel = 'Done';
    }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.tableName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(order.time, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          ...order.items.map((item) => Text('• $item')),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: KES ${order.total.toStringAsFixed(2)}'),
              Row(
                children: [
                  if (order.status != 'Completed')
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () => updateOrderStatus(order, nextStatus),
                      child: Text(actionLabel),
                    ),
                  const SizedBox(width: 8),
                  if (order.status == 'Pending')
                    OutlinedButton(
                      onPressed: () => updateOrderStatus(order, 'Cancelled'),
                      child: const Text('Cancel'),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  //  Build

  @override
  Widget build(BuildContext context) {
    final pendingCount = orders.where((o) => o.status == 'Pending').length;
    final preparingCount = orders.where((o) => o.status == 'Preparing').length;
    final completedCount = orders.where((o) => o.status == 'Completed').length;

    //  Returns a Scaffold (not ListView.builder) so appBar and body work.
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text(
          'Back to Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchOrders,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header
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
                                'Orders',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Management',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            onPressed: _showNewOrderDialog,
                            child: const Text('+ New Order'),
                          ),
                        ],
                      ),
                    ),

                    // Body
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          //  statusCard values now come from live data.
                          statusCard(
                            'Pending Orders',
                            '$pendingCount',
                            Colors.red,
                          ),
                          statusCard(
                            'Preparing',
                            '$preparingCount',
                            Colors.orange,
                          ),
                          statusCard(
                            'Completed',
                            '$completedCount',
                            Colors.green,
                          ),

                          if (orders.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                'No orders yet.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                            ...orders.map((order) => orderCard(order)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
