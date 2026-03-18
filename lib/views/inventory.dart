import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<InventoryItem> _items = [
    InventoryItem(name: 'Beer - Lager', category: 'Beer', quantity: 48),
    InventoryItem(name: 'Beer - IPA', category: 'Beer', quantity: 36),
    InventoryItem(name: 'Beer - Stout', category: 'Beer', quantity: 24),
    InventoryItem(name: 'Red Wine', category: 'Wine', quantity: 20),
    InventoryItem(name: 'White Wine', category: 'Wine', quantity: 18),
    InventoryItem(name: 'Champagne', category: 'Wine', quantity: 10),
  ];

  void _incrementQuantity(int index) {
    setState(() {
      _items[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_items[index].quantity > 0) {
        _items[index].quantity--;
      }
    });
  }

  /// 🔥 ADD ITEM POPUP
  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Item"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Item Name"),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Quantity"),
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
                if (nameController.text.isNotEmpty &&
                    categoryController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty) {
                  setState(() {
                    _items.add(
                      InventoryItem(
                        name: nameController.text,
                        category: categoryController.text,
                        quantity: int.tryParse(quantityController.text) ?? 0,
                      ),
                    );
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Inventory"),
      ),

      /// BODY
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// 🔥 BIG TITLE (VISIBLE)
            const Text(
              "Inventory Management",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              "Track and manage your stock",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            /// 🔍 SEARCH BAR
            TextField(
              decoration: InputDecoration(
                hintText: 'Search inventory...',
                prefixIcon: const Icon(Icons.search),

                filled: true,
                fillColor: Colors.grey.shade100,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ➕ ADD BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showAddItemDialog,
                icon: const Icon(Icons.add),
                label: const Text("Add New Item"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 📦 LIST
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,

                itemBuilder: (context, index) {
                  final item = _items[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(12),

                      child: Row(
                        children: [
                          /// ITEM INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  item.category,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          /// QUANTITY CONTROLS
                          Row(
                            children: [
                              Text('${item.quantity} bottles'),

                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => _decrementQuantity(index),
                              ),

                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => _incrementQuantity(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// MODEL
class InventoryItem {
  final String name;
  final String category;
  int quantity;

  InventoryItem({
    required this.name,
    required this.category,
    required this.quantity,
  });
}
