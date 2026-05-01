import 'package:wasel_driver/apps/core/utils/constants/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConstants.userTokenKey, value: token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(
      key: AppConstants.userRefreshTokenKey,
      value: refreshToken,
    );
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConstants.userTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConstants.userRefreshTokenKey);
  }

  Future<void> saveEmail(String email) async {
    await _secureStorage.write(key: AppConstants.userEmailKey, value: email);
  }

  Future<String?> getEmail() async {
    return await _secureStorage.read(key: AppConstants.userEmailKey);
  }

  Future<void> savePassword(String password) async {
    await _secureStorage.write(
      key: AppConstants.userPasswordKey,
      value: password,
    );
  }

  Future<String?> getPassword() async {
    return await _secureStorage.read(key: AppConstants.userPasswordKey);
  }

  Future<void> clearAll() async {
    final keys = await _secureStorage.readAll();
    for (var key in keys.keys) {
      if (key == AppConstants.userPasswordKey ||
          key == AppConstants.userEmailKey) {
        continue;
      }
      _secureStorage.delete(key: key);
    }
  }

  Future<void> clearEmail() async {
    await _secureStorage.delete(key: AppConstants.userEmailKey);
  }

  Future<void> clearPassword() async {
    await _secureStorage.delete(key: AppConstants.userPasswordKey);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: AppConstants.userTokenKey);
    await _secureStorage.delete(key: AppConstants.userRefreshTokenKey);
  }

  Future<void> saveLat(double lat) async {
    await _secureStorage.write(key: AppConstants.keyLat, value: lat.toString());
  }

  Future<void> saveLong(double long) async {
    await _secureStorage.write(
      key: AppConstants.keyLong,
      value: long.toString(),
    );
  }

  Future<String?> getLat() async {
    return await _secureStorage.read(key: AppConstants.keyLat);
  }

  Future<String?> getLong() async {
    return await _secureStorage.read(key: AppConstants.keyLong);
  }

  Future<void> saveIsFirstTime(bool isFirstTime) async {
    await _secureStorage.write(
      key: AppConstants.isFirstTimeKey,
      value: isFirstTime.toString(),
    );
  }

  Future<String?> getIsFirstTime() async {
    return await _secureStorage.read(key: AppConstants.isFirstTimeKey);
  }

  Future<void> saveDriverApprovedStatus(bool isApprovedStatus) async {
    await _secureStorage.write(
      key: AppConstants.driverAccountStatusKey,
      value: isApprovedStatus.toString(),
    );
  }

  Future<bool?> getDriverAccountStatus() async {
    return await _secureStorage
        .read(key: AppConstants.driverAccountStatusKey)
        ?.then((value) => value == 'true');
  }
}
