import 'package:get/state_manager.dart';

class Inventorycontroller extends GetxController {
  var itemname = '';
  var category = '';
  var quantity = '';
  inventory(item, category, quantity) {
    itemname = item;
    category = category;
    quantity = quantity;
    if (itemname == "" && category == "" && quantity == "") {
      return true;
    } else {
      return false;
    }
  }
}
