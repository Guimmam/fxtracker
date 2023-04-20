import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          themeMode: ThemeMode.system,
          isChartCurved: false,
          favoritesCurrencyList: ["EUR", "USD"],
        ));

  void setTheme(ThemeMode themeMode) {
    final updatedState = state.copyWith(themeMode: themeMode);
    emit(updatedState);
  }

  void toggleChartCurve() {
    if (state.isChartCurved) {
      final updatedState = state.copyWith(isChartCurved: false);
      emit(updatedState);
    } else {
      final updatedState = state.copyWith(isChartCurved: true);
      emit(updatedState);
    }
  }

  void addToFavorites(String code) {
    List<String> temp = state.favoritesCurrencyList;
    temp.add(code);
    final updatedState = state.copyWith(favoritesCurrencyList: temp);
    emit(updatedState);
  }

  void removeFromFavorites(String code) {
    List<String> temp = state.favoritesCurrencyList;
    temp.remove(code);
    final updatedState = state.copyWith(favoritesCurrencyList: temp);
    emit(updatedState);
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toMap();
  }
}
