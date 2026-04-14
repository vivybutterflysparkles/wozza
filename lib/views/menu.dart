import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:wozza/controllers/menucontroller.dart';
import 'package:wozza/configs/colors.dart';

class MenuScreen extends StatelessWidget {
  final MenuController controller = Get.put(MenuController());

  MenuScreen({super.key});

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCategory = 'Beer';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Menu Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Item Name"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price (KES)"),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField(
              value: selectedCategory,
              items: [
                'Beer',
                'Cocktails',
                'Wine',
                'Spirits',
                'Food',
                'Soft Drinks',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => selectedCategory = val!,
              decoration: const InputDecoration(labelText: "Category"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              controller.addMenuItem(
                nameController.text,
                double.parse(priceController.text),
                selectedCategory,
              );
              Get.back();
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Menu Management",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _showAddItemDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value)
          return const Center(child: CircularProgressIndicator());
        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: controller.menuList.length,
          itemBuilder: (context, index) {
            final item = controller.menuList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(
                  item.itemName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(item.category),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "KES ${item.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => controller.deleteMenuItem(item.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
