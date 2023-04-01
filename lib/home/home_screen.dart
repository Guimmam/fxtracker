import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtracker/currency_details/bloc/currency_details_bloc.dart';
import 'package:fxtracker/currency_details/screens/currency_details.dart';

import '../models/currency_model.dart';
import '../repos/repositories.dart';
import 'bloc/home_bloc.dart';

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is HomeLoadedState) {
            List<CurrencyModel> currencyList = state.currencyList;

            return ListView.builder(
                itemCount: currencyList.length,
                itemBuilder: ((context, index) {
                  String currency = currencyList[index]
                          .currency
                          .substring(0, 1)
                          .toUpperCase() +
                      currencyList[index].currency.substring(1);
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BlocProvider<CurrencyDetailsBloc>(
                              create: (context) => CurrencyDetailsBloc(
                                currencyDetails: RepositoryProvider.of<
                                    CurrencyDetailsRepository>(context),
                              ),
                              child: CurrencyDetails(
                                  code: currencyList[index].code,
                                  currency: currency,
                                  days: 90),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(currency),
                                  Text(currencyList[index].code),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("${currencyList[index].mid} zł"),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }));
          }
          return Container();
        },
      ),
    );
  }
}
