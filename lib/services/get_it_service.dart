import 'package:get_it/get_it.dart';
import 'package:weight_tracker/services/secure_storage_service.dart';

class GetItService {
  final getIt = GetIt.instance;

  void setup() {
    getIt.registerSingleton<SecureStorageService>(SecureStorageService());
  }

  void addService<T>(T service) {
    getIt.registerSingleton<T>(service);
  }
}
