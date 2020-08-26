import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final storage = new FlutterSecureStorage();

// Read value
  Future<String> getValue({String key}) async {
    final String value = await storage.read(key: key);
    return value;
  }

// Read all values
  Future<Map<String, String>> getAllValues() async {
    final Map<String, String> values = await storage.readAll();
    return values;
  }

// Write value
  Future<bool> setValue({String key, String value}) async {
    await storage.write(key: key, value: value);
    return true;
  }

// Delete value
  Future<bool> deleteValue({String key}) async {
    await storage.delete(key: key);
    return true;
  }

  Future<bool> deleteAllValues() async {
    await storage.deleteAll();
    return true;
  }
}
