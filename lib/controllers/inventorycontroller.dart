import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wozza/configs/api.dart'; // Assuming your IP is stored here

class InventoryItem {
  String id;
  String name;
  String category;
  int quantity;

  InventoryItem({
    this.id = '',
    required this.name,
    required this.category,
    required this.quantity,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
    );
  }
}

class Inventorycontroller extends GetxController {
  var inventoryList = <InventoryItem>[].obs;
  var isLoading = false.obs;

  // FIX 1: Use ApiConfig.baseUrl to avoid 'localhost' connection errors
  static final String apiUrl = "${ApiConfig.baseUrl}/inventory.php";

  @override
  void onInit() {
    super.onInit();
    fetchInventory();
  }

  // 1. FETCH STOCK
  Future<void> fetchInventory() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final serverData = jsonDecode(response.body);
        final List<dynamic> data = serverData['data'] ?? [];
        inventoryList.value = data
            .map((e) => InventoryItem.fromJson(e))
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 2. ADD NEW STOCK
  Future<void> addInventory(String name, String category, int quantity) async {
    if (name.isEmpty || category.isEmpty) {
      Get.snackbar('Validation', 'Please fill all fields');
      return;
    }

    try {
      // FIX 2: Send as JSON string with headers so PHP can read it
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": "add",
          "name": name,
          "category": category,
          "quantity": quantity,
        }),
      );

      if (response.statusCode == 200) {
        await fetchInventory(); // Refresh the list automatically
        Get.snackbar('Success', '$name added to stock');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  // 3. UPDATE QUANTITY (Plus/Minus buttons)
  Future<void> updateQuantity(String id, int newQuantity) async {
    if (id.isEmpty || newQuantity < 0) return;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": "update",
          "id": id,
          "quantity": newQuantity,
        }),
      );

      if (response.statusCode == 200) {
        await fetchInventory(); // Refresh UI with new numbers
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update stock: $e');
    }
  }
}
