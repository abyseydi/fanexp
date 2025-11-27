import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  saveUserKeyvalue(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  getUserKeyValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  removeUserKeyValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
