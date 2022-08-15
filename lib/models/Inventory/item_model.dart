import 'package:firebase_database/firebase_database.dart';
import 'package:liquor_inventory/models/Base/Entity.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/utils.dart';

class Item extends Entity {
  String itemCode = Utils.NOT_AVAILABLE;
  String itemName = Utils.NOT_AVAILABLE;
  double price = Utils.ZERO_DOT_ZERO;
  int quantity = Utils.ZERO;
  String category = Utils.NOT_AVAILABLE;
  String distillery = Utils.NOT_AVAILABLE;
  String location = Utils.NOT_AVAILABLE;
  String picLoc = Utils.NOT_AVAILABLE;
  double size = Utils.ZERO_DOT_ZERO; // in litres
  double age = Utils.ZERO_DOT_ZERO;
  bool get sold => quantity == 0;

  /*---------------------------Construction---------------------------*/
  Item({
    this.itemCode = Utils.NOT_AVAILABLE,
    this.itemName = Utils.NOT_AVAILABLE,
    this.price = Utils.ZERO_DOT_ZERO,
    this.quantity = Utils.ZERO,
    this.category = Utils.NOT_AVAILABLE,
    this.distillery = Utils.NOT_AVAILABLE,
    this.location = Utils.NOT_AVAILABLE,
    this.picLoc = Utils.NOT_AVAILABLE,
    this.size = Utils.ZERO_DOT_ZERO,
    this.age = Utils.ZERO_DOT_ZERO,
  }) {
    if (itemCode == Utils.NOT_AVAILABLE) {
      itemCode = Utils.genCrpytoKey(length: 12);
    }
    if (category.isEmpty) {
      category = Utils.NOT_AVAILABLE;
    }
  }

  @override
  DatabaseReference gtRef() {
    return FirebaseDatabase.instance
        .ref("items")
        .child(UserModel.instance.uid)
        .child(itemCode);
  }

/*---------------------------Serialization---------------------------*/
  @override
  Map<String, dynamic> serialize() {
    return {
      "I01": itemCode,
      'I02': itemName,
      'I03': price,
      'I04': quantity,
      'I05': category,
      'I06': distillery,
      'I07': location,
      'I08': picLoc,
      'I09': size,
      'I10': age,
    };
  }

  @override
  static Item deserialize(Map<String, dynamic> serialized) {
    return Item(
      itemCode: serialized["I01"],
      itemName: serialized["I02"],
      price: double.parse(serialized["I03"].toString()),
      quantity: serialized["I04"],
      category: serialized["I05"] ?? Utils.NOT_AVAILABLE,
      distillery: serialized["I06"],
      location: serialized["I07"],
      picLoc: serialized["I08"],
      size: double.parse(serialized["I09"].toString()),
      age: double.parse(serialized["I10"].toString()),
    );
  }
}
