import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fxtracker/repos/repositories.dart';

import '../../models/currency_rate.dart';

part 'currency_details_event.dart';
part 'currency_details_state.dart';

class CurrencyDetailsBloc
    extends Bloc<CurrencyDetailsEvent, CurrencyDetailsState> {
  final CurrencyDetailsRepository currencyDetails;
  CurrencyDetailsBloc({required this.currencyDetails})
      : super(CurrencyDetailsInitial()) {
    on<LoadRate>((event, emit) async {
      emit(RateLoading());

      try {
        CurrencyRate currencyRate =
            await currencyDetails.getCurrencyRates(event.code, event.days);
        emit(RateLoaded(currencyRate));
      } catch (e) {
        emit(RateError(e.toString()));
      }
    });
  }
}
