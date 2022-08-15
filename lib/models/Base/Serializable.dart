import 'package:firebase_database/firebase_database.dart';

// If a model is backupable to the database, then it must be seriaizable
abstract class Serializable {
  Map<String, dynamic> serialize();
}
