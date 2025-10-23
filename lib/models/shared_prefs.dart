import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._internal();
  factory SharedPrefs() => _instance;
  SharedPrefs._internal();

  static const String _parkingDataKey = 'parking_data';
  static const String _userPhoneKey = 'user_phone';
  static const String _pendingConfirmationKey = 'pending_confirmation';
  static const String _adminStatusKey = 'admin_status';

  Future<void> saveParkingData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_parkingDataKey, data);
  }

  Future<String> getParkingData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_parkingDataKey) ?? '';
  }

  Future<void> saveUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPhoneKey, phone);
  }

  Future<String> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhoneKey) ?? '';
  }

  Future<void> savePendingConfirmation(int spotId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pendingConfirmationKey, spotId);
  }

  Future<int> getPendingConfirmation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pendingConfirmationKey) ?? -1;
  }

  Future<void> clearPendingConfirmation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingConfirmationKey);
  }

  Future<void> saveAdminStatus(bool isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adminStatusKey, isAdmin);
  }

  Future<bool> getAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_adminStatusKey) ?? false;
  }
}