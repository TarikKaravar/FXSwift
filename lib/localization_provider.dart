import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  String _currentLanguage = 'tr';
  
  String get currentLanguage => _currentLanguage;
  
  // Dil çevirileri
  static const Map<String, Map<String, String>> _localizedStrings = {
  'tr': {
    'settings': 'Ayarlar',
    'settings_description': 'Uygulama tercihlerinizi buradan yönetebilirsiniz',
    'profile': 'Profil',
    'app_theme': 'Uygulama Teması',
    'language_options': 'Dil Seçenekleri',
    'version': 'Sürüm 1.0.0',
    'currency_converter': 'Döviz Çevirici',
    'language_settings': 'Dil Ayarları',
    'language_description': 'Uygulama dilini aşağıdaki seçeneklerden birini seçerek değiştirebilirsiniz.\nBu ayar tüm uygulama sayfalarında geçerli olacaktır.',
    'language_selected': 'seçildi ve kaydedildi',
    'turkish': 'Türkçe',
    'english': 'İngilizce',
    'german': 'Almanca',
    'app_themee': 'Uygulama Teması',
    'theme_settings': 'Tema Ayarları',
    'theme_txt': 'Uygulama temasını aşağıdaki düğme ile değiştirebilirsiniz. Bu ayar tüm uygulama sayfalarında geçerli olacaktır.',
    'dark_mode': 'Karanlık Mod',
    'off': 'Kapalı',
    'on': 'Açık',
    'theme_txt2': 'Tema tercihiniz otomatik olarak kaydedilir ve tüm sayfalarda uygulanır.',
    'example_txt': 'Örnek Döviz Kartı',
    // ThemeScreen translations
    'theme_screen_title': 'Uygulama Teması',
    // SwapScreen translations
    'currency_converter_tab': 'Döviz Çevirici',
    'select_currency': 'Para Birimi Seç',
    'last_updated': 'Son Güncelleme: ',
    'not_updated_yet': 'Henüz güncellenmedi',
    'usd': 'Amerikan Doları',
    'try': 'Türk Lirası',
    'eur': 'Avrupa Eurosu',
    'gbp': 'İngiliz Sterlini',
    'jpy': 'Japon Yeni',
    'chf': 'İsviçre Frangı',
    'cad': 'Kanada Doları',
    'aud': 'Avustralya Doları',
    'namekey': 'ASDASDASD',
    // HomeScreen translations
    'popular_rates': 'Popüler Kurlar',
    'updating': 'Güncelleniyor...',
    'currency_unit': 'Birim',
    'buy_rate': 'Alış',
    'sell_rate': 'Satış',
    // Currency names for HomeScreen
    'usd_try': 'Amerikan Doları',
    'eur_try': 'Euro',
    'usd_eur': 'EUR/USD',
    'gbp_try': 'İngiliz Sterlini',
    'chf_try': 'İsviçre Frangı',
    'aud_try': 'Avustralya Doları',
    'cad_try': 'Kanada Doları',
    'sar_try': 'Suudi Arabistan Riyali',
    'jpy_try': 'Japon Yeni',
    // New entry
    'news': 'Haberler',
  },
  'en': {
    'settings': 'Settings',
    'settings_description': 'You can manage your app preferences here',
    'profile': 'Profile',
    'app_theme': 'App Theme',
    'language_options': 'Language Options',
    'version': 'Version 1.0.0',
    'currency_converter': 'Currency Converter',
    'language_settings': 'Language Settings',
    'language_description': 'You can change the app language by selecting one of the options below.\nThis setting will apply to all app pages.',
    'language_selected': 'selected and saved',
    'turkish': 'Turkish',
    'english': 'English',
    'german': 'German',
    'app_themee': 'App Theme',
    'theme_settings': 'Theme Settings',
    'theme_txt': 'You can change the app theme with the button below. This setting will apply to all app pages.',
    'dark_mode': 'Dark Mode',
    'off': 'Off',
    'on': 'On',
    'theme_txt2': 'Your theme preference will be automatically saved and applied to all pages.',
    'example_txt': 'Sample Currency Card',
    // ThemeScreen translations
    'theme_screen_title': 'App Theme',
    // SwapScreen translations
    'currency_converter_tab': 'Currency Converter',
    'select_currency': 'Select Currency',
    'last_updated': 'Last Updated: ',
    'not_updated_yet': 'Not updated yet',
    'usd': 'American Dollar',
    'try': 'Turkish Lira',
    'eur': 'Euro',
    'gbp': 'British Pound',
    'jpy': 'Japanese Yen',
    'chf': 'Swiss Franc',
    'cad': 'Canadian Dollar',
    'aud': 'Australian Dollar',
    'namekey': 'ASDASDASD',
    // HomeScreen translations
    'popular_rates': 'Popular Rates',
    'updating': 'Updating...',
    'currency_unit': 'Unit',
    'buy_rate': 'Buy',
    'sell_rate': 'Sell',
    // Currency names for HomeScreen
    'usd_try': 'US Dollar',
    'eur_try': 'Euro',
    'usd_eur': 'EUR/USD',
    'gbp_try': 'British Pound',
    'chf_try': 'Swiss Franc',
    'aud_try': 'Australian Dollar',
    'cad_try': 'Canadian Dollar',
    'sar_try': 'Saudi Riyal',
    'jpy_try': 'Japanese Yen',
    // New entry
    'news': 'News',
  },
  'de': {
    'settings': 'Einstellungen',
    'settings_description': 'Sie können Ihre App-Einstellungen hier verwalten',
    'profile': 'Profil',
    'app_theme': 'App-Thema',
    'language_options': 'Sprachoptionen',
    'version': 'Version 1.0.0',
    'currency_converter': 'Währungsumrechner',
    'language_settings': 'Spracheinstellungen',
    'language_description': 'Sie können die App-Sprache ändern, indem Sie eine der folgenden Optionen auswählen.\nDiese Einstellung gilt für alle App-Seiten.',
    'language_selected': 'ausgewählt und gespeichert',
    'turkish': 'Türkisch',
    'english': 'Englisch',
    'german': 'Deutsch',
    'app_themee': 'App-Thema',
    'theme_settings': 'Themen-Einstellungen',
    'theme_txt': 'Sie können das App-Thema mit der Schaltfläche unten ändern. Diese Einstellung gilt für alle App-Seiten.',
    'dark_mode': 'Dunkelmodus',
    'off': 'Aus',
    'on': 'Ein',
    'theme_txt2': 'Ihre Themenpräferenz wird automatisch gespeichert und auf allen Seiten angewendet.',
    'example_txt': 'Beispiel-Währungskarte',
    // ThemeScreen translations
    'theme_screen_title': 'App-Thema',
    // SwapScreen translations
    'currency_converter_tab': 'Währungsumrechner',
    'select_currency': 'Währung auswählen',
    'last_updated': 'Letzte Aktualisierung: ',
    'not_updated_yet': 'Noch nicht aktualisiert',
    'usd': 'US-Dollar',
    'try': 'Türkische Lira',
    'eur': 'Euro',
    'gbp': 'Britisches Pfund',
    'jpy': 'Japanischer Yen',
    'chf': 'Schweizer Franken',
    'cad': 'Kanadischer Dollar',
    'aud': 'Australischer Dollar',
    // HomeScreen translations
    'popular_rates': 'Beliebte Kurse',
    'updating': 'Wird aktualisiert...',
    'currency_unit': 'Einheit',
    'buy_rate': 'Kauf',
    'sell_rate': 'Verkauf',
    // Currency names for HomeScreen
    'usd_try': 'US-Dollar',
    'eur_try': 'Euro',
    'usd_eur': 'EUR/USD',
    'gbp_try': 'Britisches Pfund',
    'chf_try': 'Schweizer Franken',
    'aud_try': 'Australischer Dollar',
    'cad_try': 'Kanadischer Dollar',
    'sar_try': 'Saudi-Riyal',
    'jpy_try': 'Japanischer Yen',
    // New entry
    'news': 'Nachrichten',
  },
};

  
  LocalizationProvider() {
    _loadLanguage();
  }
  
  // Kaydedilmiş dili yükle
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('language_code') ?? 'tr';
    _currentLanguage = savedLanguageCode;
    notifyListeners();
  }
  
  // Dil değiştir ve kaydet
  Future<void> changeLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    notifyListeners();
  }
  
  // Çeviri al
  String translate(String key) {
    return _localizedStrings[_currentLanguage]?[key] ?? key;
  }
  
  // Kısa method
  String t(String key) => translate(key);
}