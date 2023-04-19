part of 'internet_cubit.dart';

abstract class InternetState extends Equatable {
  const InternetState();

  @override
  List<Object> get props => [];
}

class InternetLoading extends InternetState {}

class InternetConnected extends InternetState {
  final InternetState previousState;

  const InternetConnected(this.previousState);
}

class InternetDisconnected extends InternetState {
  final InternetState previousState;

  const InternetDisconnected(this.previousState);
}
