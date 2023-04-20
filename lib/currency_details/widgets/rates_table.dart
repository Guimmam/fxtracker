// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/currency_rate.dart';

class RatesTable extends StatelessWidget {
  final List<Rate> rates;
  final String code;
  final int firstDate;
  const RatesTable({
    Key? key,
    required this.rates,
    required this.code,
    required this.firstDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    String formatDate(DateTime date) {
      DateFormat formatter = DateFormat(
        'dd/MM/yyyy',
      );
      String formatted = formatter.format(date);
      return formatted;
    }

    for (int i = firstDate; i < rates.length; i++) {
      rows.add(Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '1 $code = ${rates[i].mid} PLN',
                  textAlign: TextAlign.right,
                ),
                Text(
                  formatDate(rates[i].effectiveDate),
                ),
              ],
            ),
          ),
          const Divider()
        ],
      ));
    }
    return Expanded(
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [Text("Kurs"), Text("Data")],
                ),
              ),
              const Divider(
                height: 0,
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return rows[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}
