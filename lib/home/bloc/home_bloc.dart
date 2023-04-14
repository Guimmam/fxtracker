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
  final CurrencyListRepository currencyListRepository;
  List<String> favoritesCurrency = [];
  List<CurrencyModel> currencyList = [];

  HomeBloc({
    required this.currencyListRepository,
    required this.settingsCubit,
  }) : super(HomeInitial()) {
    settingsStreamSubscription = settingsCubit.stream.listen(
      (settingsState) async {
        favoritesCurrency = settingsState.favoritesCurrencyList;
        _loadData();
      },
    );

    on<HomeEvent>((event, emit) async {
      emit(HomeInitial());
      try {
        _loadData();
      } catch (e) {
        if (kDebugMode) {
          print("error ${e.toString()}");
        }
        emit(HomeErrorState(e.toString()));
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
    currencyList.forEach((currency) {
      if (favoritesCurrency.contains(currency.code)) {
        favoritesList.add(currency);
      }
    });
    otherCurrency
        .removeWhere((currency) => favoritesCurrency.contains(currency.code));
    emit(HomeLoadedState(otherCurrency, favoritesList));
  }

  @override
  Future<void> close() {
    settingsStreamSubscription.cancel();
    return super.close();
  }
}
