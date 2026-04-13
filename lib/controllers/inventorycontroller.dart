import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  static const String baseUrl = 'http://10.0.2.2/wozza/inventory.php';

  Future<void> fetchInventory() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final serverData = jsonDecode(response.body);
        final List<dynamic> data = serverData['data'] ?? [];
        inventoryList.value = data
            .map((e) => InventoryItem.fromJson(e))
            .toList();
      } else {
        Get.snackbar('Error', 'Server error (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not fetch inventory: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addInventory(String name, String category, int quantity) async {
    if (name.isEmpty || category.isEmpty) {
      Get.snackbar('Validation', 'Please fill all fields');
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          "action": "add",
          "name": name,
          "category": category,
          "quantity": quantity.toString(),
        },
      );
      if (response.statusCode == 200) {
        await fetchInventory();
        Get.snackbar('Success', 'Item added');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  Future<void> updateQuantity(String id, int quantity) async {
    if (id.isEmpty) return; // cannot update mock item without ID
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {"action": "update", "id": id, "quantity": quantity.toString()},
      );
      if (response.statusCode == 200) {
        await fetchInventory();
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }
}
