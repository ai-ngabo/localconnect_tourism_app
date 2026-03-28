import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── State ──────────────────────────────────────────────────────────────────────

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool notificationsEnabled;
  final bool locationServicesEnabled;

  const SettingsState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('en'),
    this.notificationsEnabled = true,
    this.locationServicesEnabled = true,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? notificationsEnabled,
    bool? locationServicesEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationServicesEnabled: locationServicesEnabled ?? this.locationServicesEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, notificationsEnabled, locationServicesEnabled];
}

// ── Cubit ──────────────────────────────────────────────────────────────────────

class SettingsCubit extends Cubit<SettingsState> {
  static const _themeKey = 'app_theme_mode';
  static const _localeKey = 'app_locale';
  static const _notificationsKey = 'app_notifications_enabled';
  static const _locationServicesKey = 'app_location_services_enabled';

  SettingsCubit() : super(const SettingsState());

  /// Call once at app start to hydrate saved preferences.
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.light.index;
    final langCode = prefs.getString(_localeKey) ?? 'en';
    final notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    final locationServicesEnabled = prefs.getBool(_locationServicesKey) ?? true;

    emit(SettingsState(
      themeMode: ThemeMode.values[themeIndex],
      locale: Locale(langCode),
      notificationsEnabled: notificationsEnabled,
      locationServicesEnabled: locationServicesEnabled,
    ));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  Future<void> setLocationServicesEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationServicesKey, enabled);
    emit(state.copyWith(locationServicesEnabled: enabled));
  }

  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeKey);
    await prefs.remove(_localeKey);
    await prefs.remove(_notificationsKey);
    await prefs.remove(_locationServicesKey);
    emit(const SettingsState());
  }

  // ── Convenience helpers for the UI ─────────────────────────────────────

  /// Map display label → ThemeMode
  static const themeModes = {
    'Light': ThemeMode.light,
    'Dark': ThemeMode.dark,
    'System': ThemeMode.system,
  };

  /// Map display label → Locale
  static const locales = {
    'English': Locale('en'),
    'French': Locale('fr'),
    'Kinyarwanda': Locale('rw'),
  };

  String get themeLabel =>
      themeModes.entries
          .firstWhere((e) => e.value == state.themeMode)
          .key;

  String get localeLabel =>
      locales.entries
          .firstWhere((e) => e.value == state.locale)
          .key;
}
