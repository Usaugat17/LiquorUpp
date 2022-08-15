import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/cubits/inventory/inventory_cubit.dart';
import 'package:liquor_inventory/models/Inventory/item_model.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/config/router.dart';
import 'package:liquor_inventory/utils/widgets.dart';
import 'package:meta/meta.dart';

part 'item_detail_state.dart';

class ItemDetailCubit extends Cubit<ItemDetailState> {
  ItemDetailCubit() : super(ItemDetailInitial());

// updated
  void updateItem(BuildContext context, Item item) {
    emit(ItemDetailItemUpdated());
  }

// add
  void addQuantity(BuildContext context, Item item) {
    item.quantity += 1;
    item.save(feedback: false);
    emit(ItemDetailItemUpdated());
    UserModel.instance.history.addItem(item);
  }

  void subQuantity(BuildContext context, Item item) {
    item.quantity = item.quantity == 0 ? 0 : item.quantity - 1;
    item.quantity == 0 ? item.save(feedback: false) : "";
    emit(ItemDetailItemUpdated());
    UserModel.instance.history.sellItem(item);
  }

// edit
  void editItem(BuildContext context, Item item) {
    Navigator.of(context)
        .pushNamed(AppRouter.edititemRoute, arguments: [item, context]);
  }

  //delete item
  void deleteItem(BuildContext context, BuildContext parentContext, Item item) {
    showDialog(
        context: context,
        builder: (context) => Widgets.confimationDialog(context, "Delete Item",
                "Item details will be wiped out permanently from the database.",
                (BuildContext context) {
              item.delete();
              UserModel.instance.inventory.tempItems
                  .removeWhere((element) => element.itemName == item.itemName);
              BlocProvider.of<InventoryCubit>(parentContext).itemUpdated(
                  parentContext, UserModel.instance.inventory.tempItems);
              Navigator.pop(context);
            }));
  }

  // sold item
  void itemSold(BuildContext context, Item item) {
    if (!item.sold) {
      showDialog(
          context: context,
          builder: (context) => Widgets.confimationDialog(
                  context, "Confirm Sold", "Is this item sold?",
                  (BuildContext context) {
                UserModel.instance.history
                    .sellItem(item, quantity: item.quantity);
                item.quantity = 0;
                emit(ItemDetailItemUpdated());
                Navigator.pop(context);
                item.save(feedback: false);
              }));
      item.save(feedback: false);
      emit(ItemDetailItemUpdated());
    } else {
      showDialog(
          context: context,
          builder: (context) => Widgets.infoDialog(
                context,
                "Item Sold",
                "This items is sold and currently unavailable in the inventory.",
              ));
    }
  }
}
