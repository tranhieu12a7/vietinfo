import 'package:vietinfo_dev_core/vietinfo_dev_core.dart';

class SharedPrefs {
  static SharedPreferences prefs;
  //SharedPrefs.internal();
  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static initializer() async {
    prefs = await SharedPreferences.getInstance();
  }

  ///get dynamic
  static T getValue<T>(dynamic key) {
    try {
      return prefs.get(key.toString()) as T;
    } catch (error) {
      throw (error);
    }
  }

  ///set dynamic
  static setValue<T>(dynamic key, dynamic value) {
    try {
      switch (T) {
        case int:
          prefs.setInt(key.toString(), value);
          break;
        case String:
          prefs.setString(key.toString(), value);
          break;
        case double:
          prefs.setDouble(key.toString(), value);
          break;
        case bool:
          prefs.setBool(key.toString(), value);
          break;
        default:
          prefs.setString(key.toString(), value);
          break;
      }
    } catch (error) {
      throw (error);
    }
  }

// Future<String> getLanguage() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString(CoreApiKeyOS.languageKey) ?? "vi";
// }

// Future<bool> saveLaguage(String lang) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.setString(CoreApiKeyOS.languageKey, lang);
// }
}