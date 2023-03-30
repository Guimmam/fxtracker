part of 'currency_details_bloc.dart';

abstract class CurrencyDetailsState extends Equatable {
  const CurrencyDetailsState();
  
  @override
  List<Object> get props => [];
}

class CurrencyDetailsInitial extends CurrencyDetailsState {}
