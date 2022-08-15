import 'package:firebase_database/firebase_database.dart';
import 'package:liquor_inventory/models/Base/Serializable.dart';

// If the model, is normalized or able to stored independently in database,
// or simply has own database reference
abstract class Normalized extends Serializable {
  DatabaseReference gtRef();
}
