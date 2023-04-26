// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fxtracker/currency_details/screens/currency_details.dart';
import 'package:fxtracker/settings/settings_screen.dart';

import '../internet/cubit/internet_cubit.dart';
import '../models/currency_model.dart';
import '../settings/cubit/settings_cubit.dart';
import 'bloc/home_bloc.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetDisconnected) {
          showSnackBar(context, "Nie masz połączenia z internetem", Colors.red,
              const Duration(days: 5), Icons.cloud_off);
        }
        if (state is InternetConnected) {
          if (state.previousState is InternetDisconnected) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            showSnackBar(context, "Znów masz połączenie z internetem",
                Colors.green, const Duration(seconds: 5), Icons.cloud);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Kursy walut"),
          actions: [
            IconButton(
                onPressed: () {
                  final route = MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  );
                  Navigator.push(context, route);
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeNoInternet) {
              return const Center(
                child: Text("Nie masz połączenia z internetem"),
              );
            }
            if (state is HomeErrorState) {
              return Center(
                  child: Column(
                children: [
                  const Text("Coś poszło nie tak"),
                  Text(state.error),
                ],
              ));
            }
            if (state is HomeLoadedState) {
              List<CurrencyModel> currencyList = state.currencyList;

              List<CurrencyModel> favoritesList = state.favoritesCurrencyList;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (favoritesList.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 12, left: 16),
                        child: Text(
                          "Ulubione",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: favoritesList.length,
                            itemBuilder: ((context, index) {
                              CurrencyModel currency = favoritesList[index];
                              return CurrencyTile(
                                currency: currency,
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 16),
                      child: Text(
                        "Pozostałe",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: currencyList.length,
                            itemBuilder: ((context, index) {
                              CurrencyModel currency = currencyList[index];
                              return CurrencyTile(
                                currency: currency,
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50)
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String title, Color backgroundColor,
      Duration duration, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Icon(
                icon,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
              );
            },
          ),
          const SizedBox(width: 10),
          Text(
            title,
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      dismissDirection: DismissDirection.none,
      duration: duration,
    ));
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
      padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CurrencyDetails(
                  code: currency.code, currency: currency.currency, days: 255),
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
                      child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black.withOpacity(0.7)
                                : Colors.white.withOpacity(0.1),
                        radius: 26,
                        child: CircleAvatar(
                            radius: 23,
                            foregroundImage: AssetImage(
                                "lib/assets/img/${currency.code}.png")),
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
    );
  }
}
