import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wozza/configs/colors.dart';
import 'package:wozza/controllers/inventorycontroller.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final Inventorycontroller controller = Get.put(Inventorycontroller());

  @override
  void initState() {
    super.initState();
    controller.fetchInventory();
  }

  /// THE UPDATED POPUP DIALOG
  /// Matches the provided reference image exactly
  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final quantityController = TextEditingController(text: "0");
    final unitController = TextEditingController();
    final minStockController = TextEditingController(text: "0");

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, a1, a2) => const SizedBox(),
      transitionBuilder: (context, a1, a2, child) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Add New Inventory Item",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Enter the details of the new inventory item.",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 20),

                      // Item Name Field
                      _customLabel("Item Name"),
                      _customField(
                        nameController,
                        "e.g., Vodka",
                        isBordered: true,
                      ),
                      const SizedBox(height: 15),

                      // Category Field
                      _customLabel("Category"),
                      _customField(categoryController, "e.g., Spirits"),
                      const SizedBox(height: 15),

                      // Quantity and Unit Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _customLabel("Quantity"),
                                _customField(
                                  quantityController,
                                  "0",
                                  isNum: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _customLabel("Unit"),
                                _customField(unitController, "e.g., bottles"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Minimum Stock Level
                      _customLabel("Minimum Stock Level"),
                      _customField(minStockController, "0", isNum: true),

                      const SizedBox(height: 25),

                      // Add Item Button
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            controller.addInventory(
                              nameController.text,
                              categoryController.text,
                              int.tryParse(quantityController.text) ?? 0,
                            );
                            Get.back();
                          },
                          child: const Text(
                            "Add Item",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Back to Dashboard",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Black Header Section
          Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: const Text(
              "Inventory Management",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search inventory...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Primary Color Add Button
                SizedBox(
                  width: 200,
                  child: ElevatedButton.icon(
                    onPressed: _showAddItemDialog,
                    icon: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      "Add New Item",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Inventory List Section
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: controller.inventoryList.length,
                itemBuilder: (context, index) {
                  final item = controller.inventoryList[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      // Thick Left Border
                      border: const Border(
                        left: BorderSide(color: Colors.black, width: 6),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Item Details
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item.category,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          // Quantity Label
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  "${item.quantity}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  "units",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Plus/Minus Buttons
                          Row(
                            children: [
                              _qtyBtn(
                                Icons.remove,
                                () => controller.updateQuantity(
                                  item.id,
                                  item.quantity - 1,
                                ),
                                isMinus: true,
                              ),
                              const SizedBox(width: 10),
                              _qtyBtn(
                                Icons.add,
                                () => controller.updateQuantity(
                                  item.id,
                                  item.quantity + 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Helper for custom form labels
  Widget _customLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 2),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  /// Helper for custom text fields that match the image
  Widget _customField(
    TextEditingController controller,
    String hint, {
    bool isBordered = false,
    bool isNum = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: !isBordered,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: isBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor, width: 2),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
      ),
    );
  }

  /// Helper for the plus/minus buttons
  Widget _qtyBtn(IconData icon, VoidCallback onPress, {bool isMinus = false}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isMinus ? Colors.white : primaryColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isMinus ? Colors.grey.shade400 : primaryColor,
          ),
        ),
        child: Icon(
          icon,
          color: isMinus ? Colors.black54 : Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
