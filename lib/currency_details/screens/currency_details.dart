import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/currency_rate.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<CurrencyDetailsBloc>().setCode(widget.code);
  }

  String formatDate(DateTime date) {
    DateFormat formatter = DateFormat('yyyy MM dd');
    String formatted = formatter.format(date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.currency,
          overflow: TextOverflow.fade,
          softWrap: true,
          textAlign: TextAlign.center,
        ),
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
                      context.read<SettingsCubit>().addToFavorites(widget.code);
                    }
                  },
                  icon: Icon(
                    state.favoritesCurrencyList.contains(widget.code)
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 30,
                  ));
            },
          )
        ],
      ),
      body: BlocBuilder<CurrencyDetailsBloc, CurrencyDetailsState>(
        builder: (context, state) {
          if (state is RateInitial) {
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
            return const Center(
              child: Text("Coś poszło nie tak "),
            );
          }
          return Container();
        },
      ),
    );
  }
}
