import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLanguage();
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'en';
    notifyListeners();
  }

  void setLanguage(String language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    notifyListeners();
  }

  String translate(String key) {
    final translations = {
      'en': {
        'home': 'Home',
        'categories': 'Categories',
        'orders': 'Orders',
        'cart': 'Cart',
        'profile': 'Profile',
        'search': 'Search for products...',
        'add_to_cart': 'Add to Cart',
        'buy_now': 'Buy Now',
        'price': 'Price',
        'delivery': 'Delivery',
        'free_delivery': 'Free Delivery',
      },
      'ha': {
        'home': 'Gida',
        'categories': 'Nau\'i',
        'orders': 'Oda',
        'cart': 'Kaya',
        'profile': 'Bayani',
        'search': 'Nemo kayayyaki...',
        'add_to_cart': 'Saka a Kaya',
        'buy_now': 'Saya Yanzu',
        'price': 'Farashi',
        'delivery': 'Isar da Kaya',
        'free_delivery': 'Isar da Kaya Kyauta',
      },
    };

    return translations[_currentLanguage]?[key] ?? key;
  }
}
