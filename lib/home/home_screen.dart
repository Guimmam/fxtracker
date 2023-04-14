// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fxtracker/currency_details/bloc/currency_details_bloc.dart';
import 'package:fxtracker/currency_details/screens/currency_details.dart';
import 'package:fxtracker/settings/settings_screen.dart';

import '../models/currency_model.dart';
import '../repos/repositories.dart';
import '../settings/cubit/settings_cubit.dart';
import 'bloc/home_bloc.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kursy walut"),
        actions: [
          IconButton(
              onPressed: () {
                final route = MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                );
                Navigator.push(context, route);
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeLoadedState) {
            List<CurrencyModel> currencyList = state.currencyList;

            List<CurrencyModel> favoritesList = state.favoritesCurrencyList;
            return ListView.builder(
              itemCount: currencyList.length + favoritesList.length + 2,
              itemBuilder: ((context, index) {
                if (index == 0) {
                  if (favoritesList.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Ulubione",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
                  return Container();
                } else if (index <= favoritesList.length) {
                  CurrencyModel currency = favoritesList[index - 1];
                  return CurrencyTile(
                    currency: currency,
                  );
                } else if (index == favoritesList.length + 1) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Pozostałe",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                } else {
                  int newIndex = index - favoritesList.length - 2;
                  if (newIndex < currencyList.length) {
                    CurrencyModel currency = currencyList[newIndex];
                    return CurrencyTile(
                      currency: currency,
                    );
                  } else {
                    return Container();
                  }
                }
              }),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class CurrencyTile extends StatelessWidget {
  const CurrencyTile({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CurrencyDetails(
                    code: currency.code,
                    currency: currency.currency,
                    days: 255),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 4, bottom: 4, right: 8),
                        child: Image.asset(
                          "lib/assets/img/${currency.code}.png",
                          width: 50,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 160,
                            child: Text(
                              currency.currency,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Text(currency.code),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "${currency.mid} zł",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
