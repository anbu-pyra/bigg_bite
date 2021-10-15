import 'Const.dart';
import 'PreferencesHelper.dart';

class Prefs {
  static Future<String> get cartData =>
      PreferencesHelper.getString(Const.CART_DATA);

  static Future setCartData(String value) =>
      PreferencesHelper.setString(Const.CART_DATA, value);
}
