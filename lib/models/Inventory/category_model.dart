import 'package:firebase_database/firebase_database.dart';
import 'package:liquor_inventory/models/Base/Entity.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/utils.dart';

class Category extends Entity {
  String name;

  // access
  List<Item> get items => UserModel.instance.inventory.items
      .where((element) => element.category == name)
      .toList();

  int get uniqueItems => items.length;
  int get totalItems => items.isEmpty
      ? 0
      : items
          .map((e) => e.quantity)
          .reduce((value, element) => value + element);

  Category({
    this.name = Utils.NOT_AVAILABLE,
  });
  @override
  DatabaseReference gtRef() {
    return FirebaseDatabase.instance
        .ref('Category')
        .child(UserModel.instance.uid)
        .child(name.toLowerCase());
  }

  @override
  Map<String, dynamic> serialize() {
    return {
      'IC01': name,
    };
  }

  @override
  static Category deserialize(Map<String, dynamic> serialized) {
    return Category(
      name: serialized["IC01"] ?? Utils.NOT_AVAILABLE,
    );
  }

  /*---------------------------Overloading---------------------------*/
  @override
  bool operator ==(dynamic other) => other.name == name;

  @override
  int get hashCode => name.hashCode;

/*---------------------------rename---------------------------*/
  void rename(String name) {
    items.forEach((element) {
      element.category = name;
      element.save(feedback: false);
    });
    delete();
    this.name = name;
    save(feedback: false);
  }
}
