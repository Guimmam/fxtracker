import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ustawienia")),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Zaookrąglij wykres "),
                    Switch(
                      value: state.isChartCurved,
                      onChanged: (bool value) {
                        context.read<SettingsCubit>().toggleChartCurve();
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text("Jasny"),
                leading: Radio(
                  value: ThemeMode.light,
                  groupValue: state.themeMode,
                  onChanged: (value) {
                    context.read<SettingsCubit>().setTheme(ThemeMode.light);
                  },
                ),
              ),
              ListTile(
                title: Text("Ciemny"),
                leading: Radio(
                  value: ThemeMode.dark,
                  groupValue: state.themeMode,
                  onChanged: (value) {
                    context.read<SettingsCubit>().setTheme(ThemeMode.dark);
                  },
                ),
              ),
              ListTile(
                title: Text("System"),
                leading: Radio(
                  value: ThemeMode.system,
                  groupValue: state.themeMode,
                  onChanged: (value) {
                    context.read<SettingsCubit>().setTheme(ThemeMode.system);
                  },
                ),
              ),
              Column(
                children: [
                  Text("Ikony stworzone przez Freepik z"),
                  Image.asset(
                    "lib/assets/img/flaticon.png",
                    width: 200,
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
