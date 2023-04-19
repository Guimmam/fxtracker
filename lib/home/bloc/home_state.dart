part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoadedState extends HomeState {
  const HomeLoadedState(this.currencyList, this.favoritesCurrencyList);
  final List<CurrencyModel> currencyList;
  final List<CurrencyModel> favoritesCurrencyList;
  @override
  List<Object> get props => [currencyList, favoritesCurrencyList];
}

class HomeErrorState extends HomeState {
  const HomeErrorState(this.error);
  final String error;
  @override
  List<Object> get props => [error];
}

class HomeNoInternet extends HomeState {}
