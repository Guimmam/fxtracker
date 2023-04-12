import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/currency_rate.dart';
import '../../repos/repositories.dart';
import '../../settings/cubit/settings_cubit.dart';
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
          actions: [
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return IconButton(
                    onPressed: () {
                      if (state.favoritesCurrencyList.contains(widget.code)) {
                        context
                            .read<SettingsCubit>()
                            .removeFromFavorites(widget.code);
                      } else {
                        context
                            .read<SettingsCubit>()
                            .addToFavorites(widget.code);
                      }
                    },
                    icon: state.favoritesCurrencyList.contains(widget.code)
                        ? Icon(
                            Icons.star_rounded,
                          )
                        : Icon(Icons.star_outline_rounded));
              },
            )
          ],
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
              List<Rate> rates = state.currencyRate.rates;

              return LineChartSample2(
                code: widget.code,
                rates: rates,
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
