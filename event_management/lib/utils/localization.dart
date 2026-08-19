import 'package:flutter/material.dart';

class AppLocalization {
  final Locale locale;
  AppLocalization(this.locale);

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'discover': 'Discover Events',
      'categories': 'Categories',
      'upcoming': 'Upcoming Events',
      'book_now': 'Book Tickets Now',
      'total_price': 'Total Price',
      'profile': 'My Profile',
      'history': 'My Booked Tickets History',
      'dark_mode': 'Dark Theme Interface',
    },
    'es': {
      'discover': 'Descubrir Eventos',
      'categories': 'Categorías',
      'upcoming': 'Próximos Eventos',
      'book_now': 'Reservar Entradas Ahora',
      'total_price': 'Precio Total',
      'profile': 'Mi Perfil',
      'history': 'Historial de Entradas',
      'dark_mode': 'Interfaz de Tema Oscuro',
    }
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async => AppLocalization(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}
