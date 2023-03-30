import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'currency_details_event.dart';
part 'currency_details_state.dart';

class CurrencyDetailsBloc extends Bloc<CurrencyDetailsEvent, CurrencyDetailsState> {
  CurrencyDetailsBloc() : super(CurrencyDetailsInitial()) {
    on<CurrencyDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
