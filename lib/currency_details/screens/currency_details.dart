import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/repositories.dart';
import '../bloc/currency_details_bloc.dart';
import '../widgets/chart.dart';
import 'package:intl/intl.dart';

class CurrencyDetails extends StatefulWidget {
  final String currency;
  final String code;
  final int days;

  const CurrencyDetails(
      {super.key,
      required this.currency,
      required this.code,
      required this.days});

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

  String formatDate(DateTime date) {
    DateFormat formatter = DateFormat('yyyy MM dd');
    String formatted = formatter.format(date);
    return formatted;
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
              return const Center(child: Text("first state"));
            }
            if (state is RateLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RateLoaded) {
              List<FlSpot> flspots = [];
              List<DateTime> days = [];
              for (int i = 1; i < state.currencyRate.rates.length + 1; i++) {
                flspots.add(
                    FlSpot(i.toDouble(), state.currencyRate.rates[i - 1].mid));
                days.add(state.currencyRate.rates[i - 1].effectiveDate);
              }
              return Column(
                children: [
                  LineChartSample2(
                    days: days,
                    flSpots: flspots,
                    code: widget.code,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.builder(
                        itemCount: state.currencyRate.rates.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "1 ${widget.code} = ${state.currencyRate.rates[index].mid} zł",
                                textAlign: TextAlign.right,
                              ),
                              Text(formatDate(state
                                  .currencyRate.rates[index].effectiveDate)),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            if (state is RateError) {
              return const Center(child: Text("Coś poszło nie tak "));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
