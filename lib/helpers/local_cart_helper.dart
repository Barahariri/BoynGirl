import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_model/cart_response.dart';

class LocalCartHelper {
  static const String _cartKey = "local_cart_data";

  static Future<void> saveCartResponse(CartResponse cartResponse) async {
    final prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(cartResponse.toJson());
    await prefs.setString(_cartKey, encodedData);
  }

  static Future<CartResponse?> getCartResponse() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString(_cartKey);
    if (encodedData != null) {
      return CartResponse.fromJson(jsonDecode(encodedData));
    }
    return null;
  }

  static Future<void> clearCartResponse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
