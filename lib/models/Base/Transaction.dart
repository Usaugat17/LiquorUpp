import 'package:liquor_inventory/models/Base/Entity.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/utils.dart';

// Base Class for sales and addition data model
abstract class Transaction extends Entity {
  //serialize
  String id = "";
  String date = Utils.gtCurrenDate();
  int quantity;
  String itemCode;

  String genId();

  Item get item => UserModel.instance.inventory.items
      .firstWhere((e) => e.itemCode == itemCode);

  Transaction.withName(String? id, String? date, this.quantity, this.itemCode) {
    this.date = date ?? Utils.gtCurrenDate();
    this.id = id ?? genId();
  }
}
