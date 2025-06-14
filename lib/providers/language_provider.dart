import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Handles the current locale selection for the application.
class LanguageProvider with ChangeNotifier {
  String _languageCode = 'en';

  String get languageCode => _languageCode;

  /// Loads the previously chosen language if available.
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString('languageCode') ?? 'en';
    notifyListeners();
  }

  /// Persists the new language code and notifies listeners.
  Future<void> setLanguage(String code) async {
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', code);
    notifyListeners();
  }
}
