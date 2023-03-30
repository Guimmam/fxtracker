import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/repositories.dart';
import '../bloc/currency_details_bloc.dart';

class CurrencyDetails extends StatefulWidget {
  final String currency;
  final String code;
  final int days;

  const CurrencyDetails(
      {required this.currency, required this.code, required this.days});

  @override
  State<CurrencyDetails> createState() => _CurrencyDetailsState();
}

class _CurrencyDetailsState extends State<CurrencyDetails> {
  late CurrencyDetailsBloc _currencyDetailsBloc;

  @override
  void initState() {
    super.initState();
    _currencyDetailsBloc = CurrencyDetailsBloc(
      currencyDetails: CurrencyDetailsRepository(),
    );
    _currencyDetailsBloc.add(LoadRate(widget.code, widget.days));
  }

  @override
  void dispose() {
    _currencyDetailsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrencyDetailsBloc>.value(
      value: _currencyDetailsBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.currency),
        ),
        body: BlocBuilder<CurrencyDetailsBloc, CurrencyDetailsState>(
          builder: (context, state) {
            if (state is CurrencyDetailsInitial) {
              return Center(child: Text("pierwszy stan "));
            }
            if (state is RateLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is RateLoaded) {
              print("załadowano dane");
              return ListView.builder(
                itemCount: state.currencyRate.rates.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.currencyRate.rates[index].effectiveDate
                          .toIso8601String()
                          .toString()),
                      Text(state.currencyRate.rates[index].mid.toString())
                    ],
                  );
                },
              );
            }
            if (state is RateError) {
              return Center(child: Text("Coś poszło nie tak "));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
