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
  bool isThereInternet = false;

  HomeBloc({
    required this.internetCubit,
    required this.currencyListRepository,
    required this.settingsCubit,
  }) : super(HomeInitial()) {
    monitorInternetCubit();
    monitorSettingsCubit();

    on<HomeEvent>((event, emit) async {
      emit(HomeInitial());
      try {
        if (isThereInternet) {
          _loadData();
        }
      } catch (e) {
        if (kDebugMode) {
          print("error ${e.toString()}");
        }
        emit(HomeErrorState(e.toString()));
      }
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
        internetCubit.stream.listen((internetState) {
      if (internetState is InternetConnected) {
        _loadData();
        isThereInternet = true;
      } else {
        isThereInternet = false;
      }
    });
  }

  Future<void> _loadData() async {
    List<CurrencyModel> favoritesList = [];
    if (currencyList.isEmpty) {
      currencyList = await currencyListRepository.getCurrencyList();
    }
    favoritesCurrency = settingsCubit.state.favoritesCurrencyList;
    List<CurrencyModel> otherCurrency = [...currencyList];
    for (var currency in currencyList) {
      if (favoritesCurrency.contains(currency.code)) {
        favoritesList.add(currency);
      }
    }
    otherCurrency
        .removeWhere((currency) => favoritesCurrency.contains(currency.code));
    emit(HomeLoadedState(otherCurrency, favoritesList));
  }

  @override
  Future<void> close() {
    settingsStreamSubscription.cancel();
    internetStreamSubscription.cancel();
    return super.close();
  }
}
