import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// App localization configuration
class AppLocalization {
  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('ar', ''), // Arabic
  ];

  /// Localizations delegates
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// Check if locale is RTL (Right-to-Left)
  static bool isRTL(Locale locale) {
    return locale.languageCode == 'ar';
  }

  /// Get text direction for locale
  static TextDirection getTextDirection(Locale locale) {
    return isRTL(locale) ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Get locale from language code
  static Locale getLocaleFromLanguageCode(String languageCode) {
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => supportedLocales.first, // Default to English
    );
  }

  /// Format date based on locale
  static String formatDate(DateTime date, Locale locale, {String? pattern}) {
    return date.toString(); // Simplified - can use intl package if needed
  }

  /// Format number based on locale
  static String formatNumber(num number, Locale locale) {
    return number.toString(); // Simplified - can use intl package if needed
  }
}
