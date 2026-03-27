import 'package:get/state_manager.dart';

class Inventorycontroller extends GetxController {
  var itemname = '';
  var category = '';
  var quantity = '';
  var search = '';
  inventory(item, category, quantity, search) {
    itemname = item;
    category = category;
    quantity = quantity;
    search = search;
    if (itemname == "" && category == "" && quantity == "" && search == "") {
      return true;
    } else {
      return false;
    }
  }
}
