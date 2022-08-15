import 'package:firebase_database/firebase_database.dart';
import 'package:liquor_inventory/models/Base/Transaction.dart' as t;
import 'package:liquor_inventory/models/user_model.dart';
import 'package:liquor_inventory/utils/utils.dart';

class Sales extends t.Transaction {
  Sales({itemCode = Utils.NOT_AVAILABLE, quantity = 0, date, salesId})
      : super.withName(salesId, date, quantity, itemCode);

  @override
  Map<String, dynamic> serialize() {
    return {
      'SL01': id,
      'SL02': date,
      'SL03': quantity,
      'SL04': itemCode,
    };
  }

  @override
  static Sales deserialize(Map<String, dynamic> serialized) {
    return Sales(
      salesId: serialized['SL01'],
      date: serialized['SL02'],
      quantity: serialized['SL03'],
      itemCode: serialized['SL04'],
    );
  }

  @override
  DatabaseReference gtRef() {
    return FirebaseDatabase.instance
        .ref('sales')
        .child(UserModel.instance.uid)
        .child(id);
  }

  @override
  String genId() {
    return "SL" + Utils.genCrpytoKey(length: 10);
  }

  /*---------------------------Logics---------------------------*/

}
