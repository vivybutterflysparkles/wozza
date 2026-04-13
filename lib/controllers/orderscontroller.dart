import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wozza/configs/api.dart';
import 'package:wozza/views/orders.dart';

class OrdersController extends GetxController {
  var ordersList = <OrderModel>[].obs;
  var isLoading = false.obs;

  static String get baseUrl => '${ApiConfig.baseUrl}/orders.php';

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  // Fetch Orders (GET)
  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final serverData = jsonDecode(response.body);
        final List<dynamic> orderData = serverData['data'] ?? [];
        ordersList.value = orderData
            .map((e) => OrderModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not fetch orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Submit Order (POST)
  Future<bool> submitOrder(String tableName, String itemsRaw) async {
    if (tableName.isEmpty || itemsRaw.isEmpty) {
      Get.snackbar('Validation', 'Please fill in all fields');
      return false;
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
        await fetchOrders();
        return true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
    return false;
  }

  // Update Status (PUT)
  Future<void> updateOrderStatus(OrderModel order, String newStatus) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': order.id, 'status': newStatus}),
      );
      if (response.statusCode == 200) {
        order.status = newStatus;
        ordersList.refresh(); // Tells GetX to update the UI
      }
    } catch (e) {
      Get.snackbar('Error', 'Update failed: $e');
    }
  }
}
