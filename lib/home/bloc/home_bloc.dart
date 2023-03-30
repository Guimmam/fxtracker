import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fxtracker/models/currency_model.dart';
import 'package:fxtracker/repos/repositories.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CurrencyListRepository _currencyListRepository;
  HomeBloc(this._currencyListRepository) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      emit(HomeInitial());
      try {
        final currencyList = await _currencyListRepository.getCurrencyList();
        emit(HomeLoadedState(currencyList));
      } catch (e) {
        print("error");
        emit(HomeErrorState(e.toString()));
      }
    });
  }
}
