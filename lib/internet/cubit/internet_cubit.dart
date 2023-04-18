import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final InternetConnectionChecker internetConnectionChecker;
  late StreamSubscription internetCheckerStream;

  InternetCubit({required this.internetConnectionChecker})
      : super(InternetLoading()) {
    monitorInternetConnection();
  }

  StreamSubscription<InternetConnectionStatus> monitorInternetConnection() {
    return internetCheckerStream =
        internetConnectionChecker.onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          emit(InternetConnected());
          print('Data connection is available.');
          break;
        case InternetConnectionStatus.disconnected:
          emit(InternetDisconnected());
          print('You are disconnected from the internet.');
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
