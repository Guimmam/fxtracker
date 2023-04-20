import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final InternetConnectionChecker internetConnectionChecker;
  late StreamSubscription internetCheckerStream;
  InternetState previousState = InternetLoading();

  InternetCubit({required this.internetConnectionChecker})
      : super(InternetLoading()) {
    monitorInternetConnection();
  }

  StreamSubscription<InternetConnectionStatus> monitorInternetConnection() {
    return internetCheckerStream =
        internetConnectionChecker.onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          previousState = state;
          emit(InternetConnected(previousState));
          break;
        case InternetConnectionStatus.disconnected:
          previousState = state;
          emit(InternetDisconnected(previousState));
          break;
      }
    });
  }

  @override
  Future<void> close() {
    internetCheckerStream.cancel();
    return super.close();
  }
}
