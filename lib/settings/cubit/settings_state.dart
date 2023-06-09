// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'settings_cubit.dart';

class SettingsState {
  final ThemeMode themeMode;
  final bool isChartCurved;
  final bool chartHapticFeedback;
  final List<String> favoritesCurrencyList;
  SettingsState({
    required this.themeMode,
    required this.isChartCurved,
    required this.favoritesCurrencyList,
    required this.chartHapticFeedback,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themeMode': themeMode.toString(),
      'isChartCurved': isChartCurved,
      'favoritesCurrencyList': favoritesCurrencyList,
      'chartHapticFeedback': chartHapticFeedback
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
        themeMode: _parseThemeMode(map['themeMode'] as String),
        isChartCurved: map['isChartCurved'] as bool,
        chartHapticFeedback: map['chartHapticFeedback'] as bool,
        favoritesCurrencyList: List<String>.from(
          (map['favoritesCurrencyList'] as List<String>),
        ));
  }

  static ThemeMode _parseThemeMode(String themeModeString) {
    switch (themeModeString) {
      case 'ThemeMode.system':
        return ThemeMode.system;
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? isChartCurved,
    bool? chartHapticFeedback,
    List<String>? favoritesCurrencyList,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      isChartCurved: isChartCurved ?? this.isChartCurved,
      chartHapticFeedback: chartHapticFeedback ?? this.chartHapticFeedback,
      favoritesCurrencyList:
          favoritesCurrencyList ?? this.favoritesCurrencyList,
    );
  }
}
