import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  bool get isSubscribed => _prefs.getBool(AppStrings.prefsSubscribedKey) ?? false;

  Future<void> setSubscribed(bool value) async {
    await _prefs.setBool(AppStrings.prefsSubscribedKey, value);
  }
}
