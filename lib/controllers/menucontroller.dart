import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wozza/configs/api.dart';

class MenuItem {
  final String id;
  final String itemName;
  final double price;
  final String category;

  MenuItem({
    required this.id,
    required this.itemName,
    required this.price,
    required this.category,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'].toString(),
      itemName: json['item_name'],
      price: double.parse(json['price'].toString()),
      category: json['category'],
    );
  }
}

class MenuController extends GetxController {
  var menuList = <MenuItem>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchMenu();
    super.onInit();
  }

  Future<void> fetchMenu() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('${ApiConfig.baseUrl}/menu.php'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;
        menuList.assignAll(data.map((e) => MenuItem.fromJson(e)).toList());
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> addMenuItem(String name, double price, String category) async {
    await http.post(
      Uri.parse('${ApiConfig.baseUrl}/menu.php'),
      body: jsonEncode({
        'item_name': name,
        'price': price,
        'category': category,
      }),
    );
    fetchMenu();
  }

  Future<void> deleteMenuItem(String id) async {
    await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/menu.php'),
      body: jsonEncode({'id': id}),
    );
    fetchMenu();
  }

  double getPriceByName(String name) {
    return menuList
        .firstWhere(
          (e) => e.itemName == name,
          orElse: () => MenuItem(id: '', itemName: '', price: 0, category: ''),
        )
        .price;
  }
}
