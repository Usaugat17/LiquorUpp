import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/cubits/history/history_cubit.dart';
import 'package:liquor_inventory/cubits/inventory/inventory_cubit.dart';
import 'package:liquor_inventory/models/Base/Entity.dart';
import 'package:liquor_inventory/models/History/history.dart';
import 'package:liquor_inventory/models/Inventory/inventory.dart';
import 'package:liquor_inventory/models/Settings.dart';
import 'package:liquor_inventory/utils/utils.dart';

// an access hub for the whole app's Data Models and Business Logics
// also  Is simple data model of an User, storing basics user information and settings.
class UserModel extends Entity {
  //serialized
  String uid = Utils.NOT_AVAILABLE;
  String email = Utils.NOT_AVAILABLE;
  String password = Utils.NOT_AVAILABLE;
  String profilePic = Utils.NOT_AVAILABLE;
  String businessName = Utils.NOT_AVAILABLE;
  String businessLocation = Utils.NOT_AVAILABLE;
  String contact = Utils.NOT_AVAILABLE;
  UserSettings settings = UserSettings.instance;

  // accessibilty
  History history = History.instance;
  Inventory inventory = Inventory.instance;

  @override
  DatabaseReference gtRef() {
    return FirebaseDatabase.instance.ref('user').child(uid);
  }

  /*---------------------------Initialization---------------------------*/
  void init(BuildContext context, {onlyInventory: true}) {
    inventory.load(
      itemsLoaded: (items) {
        UserModel.instance.inventory.items = items;
        BlocProvider.of<InventoryCubit>(context).itemUpdated(context, items);
      },
      catsLoaded: (cats) {
        // print('Cats: ${cats.length}');
        BlocProvider.of<InventoryCubit>(context).catsUpdated(context, cats);
      },
    );
    onlyInventory
        ? ""
        : history.load(
            salesLoaded: (sales) {
              UserModel.instance.history.sales = sales;
              BlocProvider.of<HistoryCubit>(context).salesUpdated(context);
            },
            additionsLoaded: (additions) {
              UserModel.instance.history.additions = additions;
              BlocProvider.of<HistoryCubit>(context).additionUpdated(context);
            },
          );
  }

  /*---------------------------Construction---------------------------*/
  static UserModel instance = UserModel._();
  UserModel._();

/*---------------------------Serialization---------------------------*/
  @override
  Map<String, dynamic> serialize() {
    return {
      'U01': uid,
      'U02': email,
      'U03': password,
      'U04': profilePic,
      'U05': businessName,
      'U06': businessLocation,
      'U07': contact,
      'U08': settings.serialize(),
    };
  }

  @override
  static UserModel deserialize(Map<String, dynamic> serialized) {
    instance.uid = serialized['U01'];
    instance.email = serialized['U02'];
    instance.password = serialized['U03'];
    instance.profilePic = serialized['U04'];
    instance.businessName = serialized['U05'];
    instance.businessLocation = serialized['U06'];
    instance.contact = serialized['U07'];
    instance.settings = UserSettings.deserialize(
        Map<String, dynamic>.from(serialized['U08'] as Map));

    return instance;
  }
}
