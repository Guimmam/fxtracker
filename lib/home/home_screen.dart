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
            return BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, settingsState) {
                List<CurrencyModel> currencyList = state.currencyList;
                List<CurrencyModel> favoritesList = state.favoritesCurrencyList;
                return ListView.builder(
                  itemCount: currencyList.length + favoritesList.length + 2,
                  itemBuilder: ((context, index) {
                    String currency;
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("Ulubione"),
                      );
                    } else if (index <= favoritesList.length) {
                      return CurrencyTile(
                        currencyList: favoritesList,
                        currency: favoritesList[index - 1].code,
                        index: index - 1,
                      );
                    } else if (index == favoritesList.length + 1) {
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("Pozostałe"),
                      );
                    } else {
                      int newIndex = index - favoritesList.length - 2;
                      if (newIndex < currencyList.length) {
                        currency = currencyList[newIndex]
                                .currency
                                .substring(0, 1)
                                .toUpperCase() +
                            currencyList[newIndex].currency.substring(1);
                        return CurrencyTile(
                          currencyList: currencyList,
                          currency: currencyList[newIndex].code,
                          index: newIndex,
                        );
                      } else {
                        return Container(); // Placeholder widget, może być dostosowany do potrzeb
                      }
                    }
                  }),
                );
              },
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
    required this.currencyList,
    required this.currency,
    required this.index,
  }) : super(key: key);

  final List<CurrencyModel> currencyList;
  final String currency;
  final int index;

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
                    code: currencyList[index].code,
                    currency: currency,
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
                          "lib/assets/img/${currencyList[index].code}.png",
                          width: 50,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 160,
                            child: Text(
                              currency,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Text(currencyList[index].code),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "${currencyList[index].mid} zł",
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
