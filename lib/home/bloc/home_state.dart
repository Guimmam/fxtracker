part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoadedState extends HomeState {
  HomeLoadedState(this.currencyList);
  final List<CurrencyModel> currencyList;
  @override
  List<Object> get props => [currencyList];
}

class HomeErrorState extends HomeState {
  HomeErrorState(this.error);
  final String error;
  @override
  List<Object> get props => [error];
}
