part of 'currency_details_bloc.dart';

abstract class CurrencyDetailsState extends Equatable {
  const CurrencyDetailsState();

  @override
  List<Object> get props => [];
}

class CurrencyDetailsInitial extends CurrencyDetailsState {}

class RateLoading extends CurrencyDetailsState {}

class RateLoaded extends CurrencyDetailsState {
  const RateLoaded(this.currencyRate);
  final CurrencyRate currencyRate;
  @override
  List<Object> get props => [currencyRate];
}

class RateError extends CurrencyDetailsState {
  final String error;
  const RateError(this.error);
  @override
  List<Object> get props => [error];
}
