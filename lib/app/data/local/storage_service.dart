import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _box = GetStorage();

  static const String _authTokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userTypeKey = 'user_type';

  static Future<void> init() async {
    await GetStorage.init();
    print('📦 StorageService: Persistent Storage Ready');
  }

  static Future<void> saveAuthToken(String token) async {
    await _box.write(_authTokenKey, token);
    print('📦 Storage: Token Saved');
  }

  static String? getAuthToken() {
    return _box.read(_authTokenKey);
  }

  static Future<void> saveUserType(String type) async {
    await _box.write(_userTypeKey, type);
    print('📦 Storage: User Type ($type) Saved');
  }

  static String? getUserType() {
    return _box.read(_userTypeKey);
  }

  static Future<void> setLoggedIn(bool value) async {
    await _box.write(_isLoggedInKey, value);
    // Force write to disk to survive immediate restart
    await _box.save();
    print('📦 Storage: Logged In State -> $value');
  }

  static bool isLoggedIn() {
    final loggedIn = _box.read(_isLoggedInKey) ?? false;
    return loggedIn;
  }

  static Future<void> logout() async {
    await _box.erase();
    print('📦 Storage: All Data Cleared');
  }
}
