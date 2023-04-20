// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fxtracker/internet/cubit/internet_cubit.dart';
import 'package:fxtracker/repos/repositories.dart';
import 'package:fxtracker/settings/cubit/settings_cubit.dart';

import 'currency_details/bloc/currency_details_bloc.dart';
import 'home/bloc/home_bloc.dart';
import 'home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FlutterNativeSplash.remove();
  runApp(MyApp(
    internetConnectionChecker: InternetConnectionChecker(),
  ));
}

class MyApp extends StatefulWidget {
  final InternetConnectionChecker internetConnectionChecker;
  const MyApp({
    Key? key,
    required this.internetConnectionChecker,
  }) : super(key: key);

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
    return MultiRepositoryProvider(
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
            BlocProvider(create: (context) => SettingsCubit()),
            BlocProvider(
                create: (context) => InternetCubit(
                    internetConnectionChecker:
                        widget.internetConnectionChecker)),
            BlocProvider(
              create: (context) => HomeBloc(
                currencyListRepository:
                    RepositoryProvider.of<CurrencyListRepository>(context),
                settingsCubit: context.read<SettingsCubit>(),
                internetCubit: context.read<InternetCubit>(),
              ),
            ),
            BlocProvider(
              create: (context) => CurrencyDetailsBloc(
                  internetCubit: context.read<InternetCubit>(),
                  currencyDetails:
                      RepositoryProvider.of<CurrencyDetailsRepository>(
                          context)),
            ),
          ],
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'FxTracker',
                theme: ThemeData(
                  platform: TargetPlatform.iOS,
                  appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
                  //colorSchemeSeed: Colors.blue,
                  useMaterial3: true,
                ),
                darkTheme: ThemeData.dark(
                  useMaterial3: true,
                ).copyWith(
                  appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
                  platform: TargetPlatform.iOS,
                ),
                themeMode: state.themeMode,
                home: const Home(),
              );
            },
          ),
        ));
  }
}
