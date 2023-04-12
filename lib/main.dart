import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:fxtracker/repos/repositories.dart';
import 'package:fxtracker/settings/cubit/settings_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

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
              create: (context) => HomeBloc(
                  RepositoryProvider.of<CurrencyListRepository>(context),
                  settingsCubit: SettingsCubit())
                ..add(LoadHomeEvent()),
            ),
            BlocProvider(
              create: (context) => CurrencyDetailsBloc(
                  currencyDetails:
                      RepositoryProvider.of<CurrencyDetailsRepository>(
                          context)),
            ),
          ],
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  platform: TargetPlatform.iOS,
                  //colorSchemeSeed: Colors.blue,
                  useMaterial3: true,
                ),
                darkTheme: ThemeData.dark(
                  useMaterial3: true,
                ).copyWith(
                  platform: TargetPlatform.iOS,
                ),
                themeMode: state.themeMode,
                home: Home(),
              );
            },
          ),
        ));
  }
}
