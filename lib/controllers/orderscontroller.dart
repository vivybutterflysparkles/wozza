import 'package:get/state_manager.dart';

class orderscontroller extends GetxController {
  var tablenumber = '';
  var itemname = '';
  orders(table, item) {
    tablenumber = table;
    itemname = item;
    if (itemname == "" && tablenumber == "") {
      return true;
    } else {
      return false;
    }
  }
}
