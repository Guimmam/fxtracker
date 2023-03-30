import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/currency_model.dart';
import '../repos/repositories.dart';
import 'bloc/home_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(RepositoryProvider.of<CurrencyList>(context))
            ..add(LoadHomeEvent()),
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is HomeInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is HomeLoadedState) {
            List<CurrencyModel> currencyList = state.currencyList;
            return ListView.builder(
                itemCount: currencyList.length,
                itemBuilder: ((context, index) => Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currencyList[index]
                                        .currency
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    currencyList[index].currency.substring(1)),
                                Text(currencyList[index].code),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                    currencyList[index].mid.toString() + " zł"),
                              ],
                            )
                          ],
                        ),
                      )),
                    )));
          }
          return Container();
        }),
      ),
    );
  }
}
