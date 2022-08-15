import 'package:liquor_inventory/models/Inventory/category_model.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';

// an access hub for the Inventory Page
// basically it houses all the essential datamodels and business logic for Inventory page
class Inventory {
  // all
  List<Item> items = [];
  List<Category> categories = [];

  // temp
  List<Item> tempItems = [];

  /*---------------------------Construction---------------------------*/
  static Inventory instance = Inventory._();
  Inventory._();

  void load({itemsLoaded, catsLoaded}) {
    Item().all((List items) {
      List<Item> ret = [];
      for (dynamic item in items) {
        try {
          var val = Map<String, dynamic>.from(item);
          ret.add(Item.deserialize(val));
        } catch (e) {
          continue;
        }
      }
      itemsLoaded(ret);
    });

    Category().all((List categories) {
      catsLoaded(categories
          .map((e) => Category.deserialize(Map<String, dynamic>.from(e)))
          .toList());
    });
  }
}
