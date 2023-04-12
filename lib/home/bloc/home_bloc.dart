import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fxtracker/models/currency_model.dart';
import 'package:fxtracker/repos/repositories.dart';
import 'package:fxtracker/settings/cubit/settings_cubit.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SettingsCubit settingsCubit;
  late StreamSubscription settingsStreamSubscription;
  final CurrencyListRepository _currencyListRepository;
  List<String> favoritesCurrency = [];

  HomeBloc(
    this._currencyListRepository, {
    required this.settingsCubit,
  }) : super(HomeInitial()) {
    settingsStreamSubscription = settingsCubit.stream.listen(
      (settingsState) {
        print(
            "settingsStreamSubscription: $settingsState"); // Log do sprawdzenia, czy otrzymujesz wartości ze strumienia
        favoritesCurrency = settingsState.favoritesCurrencyList;
      },
      onError: (error) {
        print(
            "settingsStreamSubscription error: $error"); // Log do sprawdzenia ewentualnych błędów w strumieniu
      },
      onDone: () {
        print(
            "settingsStreamSubscription done"); // Log do sprawdzenia, czy strumień został zamknięty
      },
    );

    on<HomeEvent>((event, emit) async {
      emit(HomeInitial());
      try {
        final currencyList = await _currencyListRepository.getCurrencyList();
        List<CurrencyModel> favoritesList = [];
        favoritesCurrency = settingsCubit.state.favoritesCurrencyList;

        currencyList.forEach((currency) {
          if (favoritesCurrency.contains(currency.code)) {
            favoritesList.add(currency);
          }
        });
        currencyList.removeWhere(
            (currency) => favoritesCurrency.contains(currency.code));
        emit(HomeLoadedState(currencyList, favoritesList));
      } catch (e) {
        if (kDebugMode) {
          print("error ${e.toString()}");
        }
        emit(HomeErrorState(e.toString()));
      }
    });
  }
}
