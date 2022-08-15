import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquor_inventory/models/Inventory/category_model.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:liquor_inventory/utils/notificaion_uitls.dart';
import 'package:liquor_inventory/utils/utils.dart';
import 'package:liquor_inventory/utils/widgets.dart';
import 'package:meta/meta.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit() : super(InventoryInitial());

// data updated || loaded
  void itemUpdated(BuildContext context, List<Item> items) {
    UserModel.instance.inventory.tempItems = items;
    emit(InventoryItemsUpdated());
  }

  void catsUpdated(BuildContext context, List<Category> cats) {
    UserModel.instance.inventory.categories = cats;
    emit(InventoryCategoryUpdated());
  }

// sort
  void sortToggle(BuildContext context) {
    emit(InventoryItemSort());
  }

  void sortBy(BuildContext context, String by) {
    Utils.sortBy(context, by);
  }

  void sortAccend(BuildContext context, String by) {
    Utils.sortBy(context, by, ascending: true);
  }

  void sortDescend(BuildContext context, String by) {
    // print("here");
    Utils.sortBy(context, by, ascending: false);
  }

//search
  void searchToggle(BuildContext context) {
    emit(InventoryItemSearch());
  }

  void searchItem(BuildContext context, String by, {arg1, arg2}) {
    // print("By: $by Arg1: $arg1 Arg2: $arg2");

    Utils.searchBy(by)(context, arg1, arg2);
  }

//add
  void addCatForm(BuildContext context) {
    emit(InvetoryItemAddCategory());
  }

  void addCat(BuildContext context, Category cat) {
    cat.save();
    UserModel.instance.inventory.categories
        .removeWhere((element) => element.name == cat.name);
    UserModel.instance.inventory.categories.add(cat);
    catsUpdated(context, UserModel.instance.inventory.categories);
    emit(InventoryCategoryUpdated());
    emit(InvetoryItemCategoryAdded());
  }

// delete
  void deleteItem(BuildContext context, Item item) {
    showDialog(
        context: context,
        builder: (context) => Widgets.confimationDialog(context, "Delete Item",
                "Item details will be wiped out permanently from the database.",
                (BuildContext context) {
              item.delete();
              UserModel.instance.inventory.tempItems
                  .removeWhere((element) => element.itemName == item.itemName);
              emit(InventoryItemsUpdated());
              Navigator.pop(context);
            }));
  }

  void deleteCat(BuildContext context, Category cat) {
    showDialog(
        context: context,
        builder: (context) => Widgets.confimationDialog(
                context,
                "Delete Category",
                "Deleting a category will delete all the items of that category\n Do you want to proceed?",
                (BuildContext context) {
              // print("here");
              cat.delete();
              UserModel.instance.inventory.categories
                  .removeWhere((element) => element.name == cat.name);
              emit(InventoryCategoryUpdated());
              Navigator.pop(context);
            }));
  }

  // edit

  void editCategory(BuildContext context, Category category) {
    showDialog(
        context: context,
        builder: (context) => Widgets.inputDialog(
              context,
              "Edit Category",
              "",
              onChange: (v) {
                Utils.tempText = v;
              },
              onComplete: (BuildContext context) {
                category.rename(Utils.tempText);
                emit(InventoryCategoryUpdated());
                Navigator.pop(context);
              },
            ));
  }

  // sold detail
  void soldDetail(BuildContext context, Item item) {
    showDialog(
        context: context,
        builder: (context) => Widgets.infoDialog(
              context,
              "Item Sold",
              "This items is sold and currently unavailable in the inventory.",
            ));
  }

  // navigate
  void addItemForm(BuildContext context, {barCode = Utils.NOT_AVAILABLE}) {
    emit(InventoryExpandableToggle(false));
    Navigator.of(context).pushNamed(AppRouter.additemRoute, arguments: barCode);
    // print("here");
  }
}
