import 'package:liquor_inventory/models/Base/Serializable.dart';

class UserSettings extends Serializable {
  // notification
  bool notify = true;
  int notifyLowThreshold = 0;

  /*---------------------------Construction---------------------------*/
  static UserSettings instance = UserSettings._();
  UserSettings._();

  @override
  Map<String, dynamic> serialize() {
    return {
      "US01": notify,
      "US02": notifyLowThreshold,
    };
  }

  static UserSettings deserialize(Map<String, dynamic> serialized) {
    instance.notify = serialized['US01'];
    instance.notifyLowThreshold = serialized['US02'];

    return instance;
  }
}
