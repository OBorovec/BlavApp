import 'package:shared_preferences/shared_preferences.dart';

class PrefsRepo {
  final SharedPreferences _prefsInstance;

  static const String keyLang = 'lang';
  static const String keyTheme = 'theme';
  static const String keyEventFocus = 'eventFocus';

  PrefsRepo(SharedPreferences prefs) : _prefsInstance = prefs;

  String? loadLang() {
    return _prefsInstance.getString(keyLang);
  }

  void saveLang(String? value) {
    _prefsInstance.setString(keyLang, value ?? '');
  }

  String? loadTheme() {
    return _prefsInstance.getString(keyTheme);
  }

  void saveTheme(String? value) {
    _prefsInstance.setString(keyTheme, value ?? '');
  }

  String? loadEventFocus() {
    return _prefsInstance.getString(keyEventFocus);
  }

  void saveEventFocus(String? value) {
    _prefsInstance.setString(keyEventFocus, value ?? '');
  }
}