import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:liquor_inventory/models/Base/Normalized.dart';
import 'package:liquor_inventory/utils/utils.dart';

// Any model is an entity if its has basic database access functionaly (CRUD)
// i.e save | get | delete
abstract class Entity extends Normalized {
  save({onComplete, feedback = true}) async {
    feedback ? Utils.toast("Saving Item") : "";
    await gtRef().set(serialize()).then((_) {
      feedback ? Utils.toast("Saved Successfully.") : "";
    }).catchError((error) {
      Utils.toast("Saving Error");
    });
  }

  fetch(onComplete) {
    gtRef().onValue.listen((DatabaseEvent event) {
      Map ret = {};
      final data = event.snapshot.value;
      ret = Map<String, dynamic>.from(event.snapshot.value as Map);
      onComplete(ret);
    });
  }

  all(onComplete) {
    // print("Ref: ${gtRef().parent!.path}");
    gtRef().parent!.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null) {
        final ret = Map<String, dynamic>.from(data as Map);
        onComplete(data.values.toList());
      }
    });
  }

  delete() {
    gtRef().remove();
  }
}
