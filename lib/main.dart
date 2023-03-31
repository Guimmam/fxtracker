import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:fxtracker/models/currency_model.dart';
import 'package:fxtracker/repos/repositories.dart';

import 'currency_details/bloc/currency_details_bloc.dart';
import 'home/bloc/home_bloc.dart';
import 'home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setHighRefreshRateOnAndroid();
  }

  void setHighRefreshRateOnAndroid() async {
    if (Platform.isAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (context) => CurrencyListRepository(),
              ),
              RepositoryProvider(
                create: (context) => CurrencyDetailsRepository(),
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => HomeBloc(
                      RepositoryProvider.of<CurrencyListRepository>(context))
                    ..add(LoadHomeEvent()),
                ),
                BlocProvider(
                  create: (context) => CurrencyDetailsBloc(
                      currencyDetails:
                          RepositoryProvider.of<CurrencyDetailsRepository>(
                              context)),
                ),
              ],
              child: Home(),
            )));
  }
}
