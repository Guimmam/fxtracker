import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(themeMode: ThemeMode.system, isChartCurved: false));

  void setSystemTheme() {
    final updatedState = SettingsState(
        themeMode: ThemeMode.system, isChartCurved: state.isChartCurved);
    emit(updatedState);
  }

  void setLightTheme() {
    final updatedState = SettingsState(
        themeMode: ThemeMode.light, isChartCurved: state.isChartCurved);
    emit(updatedState);
  }

  void setDarkTheme() {
    final updatedState = SettingsState(
        themeMode: ThemeMode.dark, isChartCurved: state.isChartCurved);
    emit(updatedState);
  }

  void toogleChartCurve() {
    if (state.isChartCurved) {
      final updatedState =
          SettingsState(themeMode: state.themeMode, isChartCurved: false);
      emit(updatedState);
    } else {
      final updatedState =
          SettingsState(themeMode: state.themeMode, isChartCurved: true);
      emit(updatedState);
    }
  }
}
