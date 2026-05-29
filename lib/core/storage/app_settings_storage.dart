import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSettingsKeys {
  static const generalNotification = 'app_setting_general_notification';
  static const sound = 'app_setting_sound';
  static const vibrate = 'app_setting_vibrate';
  static const appUpdates = 'app_setting_app_updates';
  static const billReminder = 'app_setting_bill_reminder';
  static const promotion = 'app_setting_promotion';
  static const discountAvailable = 'app_setting_discount_available';
  static const paymentRequest = 'app_setting_payment_request';
  static const newServiceAvailable = 'app_setting_new_service_available';
  static const newTipsAvailable = 'app_setting_new_tips_available';

  static const all = <String>{
    generalNotification,
    sound,
    vibrate,
    appUpdates,
    billReminder,
    promotion,
    discountAvailable,
    paymentRequest,
    newServiceAvailable,
    newTipsAvailable,
  };

  AppSettingsKeys._();
}

class AppSettingsStorage {
  final FlutterSecureStorage _storage;

  const AppSettingsStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<bool> readBool(String key, {bool fallback = false}) async {
    final value = await _storage.read(key: key);
    if (value == null) return fallback;
    return value.toLowerCase() == 'true';
  }

  Future<void> writeBool(String key, bool value) {
    return _storage.write(key: key, value: value.toString());
  }

  Future<int?> readInt(String key) async {
    final value = await _storage.read(key: key);
    return value == null ? null : int.tryParse(value);
  }

  Future<void> writeInt(String key, int value) {
    return _storage.write(key: key, value: '$value');
  }

  Future<Map<String, bool>> readAll() async {
    final result = <String, bool>{};
    for (final key in AppSettingsKeys.all) {
      result[key] = await readBool(key);
    }
    return result;
  }
}
