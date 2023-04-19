import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fxtracker/internet/cubit/internet_cubit.dart';
import 'package:fxtracker/models/currency_model.dart';
import 'package:fxtracker/repos/repositories.dart';
import 'package:fxtracker/settings/cubit/settings_cubit.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SettingsCubit settingsCubit;
  final InternetCubit internetCubit;

  late StreamSubscription settingsStreamSubscription;
  late StreamSubscription internetStreamSubscription;
  final CurrencyListRepository currencyListRepository;
  List<String> favoritesCurrency = [];
  List<CurrencyModel> currencyList = [];

  HomeBloc({
    required this.internetCubit,
    required this.currencyListRepository,
    required this.settingsCubit,
  }) : super(HomeInitial()) {
    monitorInternetCubit();
    monitorSettingsCubit();

    on<HomeEvent>((event, emit) async {
      emit(HomeInitial());
    });
  }

  StreamSubscription<SettingsState> monitorSettingsCubit() {
    return settingsStreamSubscription = settingsCubit.stream.listen(
      (settingsState) async {
        favoritesCurrency = settingsState.favoritesCurrencyList;

        _loadData();
      },
    );
  }

  StreamSubscription<InternetState> monitorInternetCubit() {
    return internetStreamSubscription =
        internetCubit.stream.listen((internetState) async {
      if (internetState is InternetConnected) {
        try {
          currencyList = await currencyListRepository.getCurrencyList();
        } catch (e) {
          if (kDebugMode) {
            print("error ${e.toString()}");
          }
          emit(HomeErrorState(e.toString()));
        }
        _loadData();
      }
    });
  }

  void _loadData() {
    if (currencyList.isNotEmpty) {
      List<CurrencyModel> favoritesList = [];
      favoritesCurrency = settingsCubit.state.favoritesCurrencyList;
      List<CurrencyModel> otherCurrency = [...currencyList];
      for (int i = 0; i < favoritesCurrency.length; i++) {
        for (int j = 0; j < currencyList.length; j++) {
          if (currencyList[j].code == favoritesCurrency[i]) {
            favoritesList.add(currencyList[j]);
            break;
          }
        }
      }
      otherCurrency
          .removeWhere((currency) => favoritesCurrency.contains(currency.code));
      emit(HomeLoadedState(otherCurrency, favoritesList));
    }
  }

  @override
  Future<void> close() {
    settingsStreamSubscription.cancel();
    internetStreamSubscription.cancel();
    return super.close();
  }
}
