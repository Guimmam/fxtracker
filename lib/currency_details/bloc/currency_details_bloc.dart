import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fxtracker/repos/repositories.dart';

import '../../internet/cubit/internet_cubit.dart';
import '../../models/currency_rate.dart';

part 'currency_details_event.dart';
part 'currency_details_state.dart';

class CurrencyDetailsBloc
    extends Bloc<CurrencyDetailsEvent, CurrencyDetailsState> {
  final InternetCubit internetCubit;
  late StreamSubscription internetStreamSubscription;
  final CurrencyDetailsRepository currencyDetails;
  String code = "";
  bool isThereInternet = true;
  CurrencyRate? currencyRate;

  CurrencyDetailsBloc(
      {required this.currencyDetails, required this.internetCubit})
      : super(RateInitial()) {
    monitorInternetCubit();
  }
  StreamSubscription<InternetState> monitorInternetCubit() {
    return internetStreamSubscription =
        internetCubit.stream.listen((internetState) async {
      if (internetState is InternetConnected) {
        isThereInternet = true;

        if (currencyRate == null) {
          loadRate();
        }
      } else {
        isThereInternet = false;
      }
    });
  }

  void loadRate() async {
    emit(RateLoading());
    if (isThereInternet) {
      try {
        currencyRate = await currencyDetails.getCurrencyRates(code);
        emit(RateLoaded(currencyRate!));
      } catch (e) {
        currencyRate = null;
        if (kDebugMode) {
          print(e.toString());
        }
      }
    } else {
      currencyRate = null;
    }
  }

  void setCode(String code) {
    this.code = code;
    loadRate();
  }

  @override
  Future<void> close() {
    internetStreamSubscription.cancel();
    return super.close();
  }
}
