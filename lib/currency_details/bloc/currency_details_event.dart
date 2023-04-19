part of 'currency_details_bloc.dart';

abstract class CurrencyDetailsEvent extends Equatable {
  const CurrencyDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadRate extends CurrencyDetailsEvent {
  final String code;

  const LoadRate(this.code);
}
