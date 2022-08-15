import 'package:firebase_database/firebase_database.dart';
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/models/Base/Transaction.dart' as t;

import 'package:liquor_inventory/utils/utils.dart';

class Addition extends t.Transaction {
  /*---------------------------Construction---------------------------*/
  Addition({itemCode = Utils.NOT_AVAILABLE, quantity = 0, date, id})
      : super.withName(id, date, quantity, itemCode);

  /*---------------------------Serialization---------------------------*/

  @override
  Map<String, dynamic> serialize() {
    return {
      'AD01': id,
      'AD02': date,
      'AD03': quantity,
      'AD04': itemCode,
    };
  }

  @override
  static Addition deserialize(Map<String, dynamic> serialized) {
    return Addition(
      id: serialized['AD01'],
      date: serialized['AD02'],
      quantity: serialized['AD03'],
      itemCode: serialized['AD04'],
    );
  }

  @override
  DatabaseReference gtRef() {
    return FirebaseDatabase.instance
        .ref('additions')
        .child(UserModel.instance.uid)
        .child(id);
  }

  @override
  String genId() {
    return "AD" + Utils.genCrpytoKey(length: 10);
  }
}
