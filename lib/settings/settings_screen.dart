import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ustawienia")),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Wykres",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SwitchListTile(
                          contentPadding: const EdgeInsets.only(left: 10),
                          title: const Text("Zaookrąglone rogi"),
                          value: state.isChartCurved,
                          onChanged: (bool value) {
                            context.read<SettingsCubit>().toggleChartCurve();
                          },
                          secondary: const Icon(Icons.show_chart_rounded),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SwitchListTile(
                          contentPadding: const EdgeInsets.only(left: 10),
                          title: const Text("Wibracja po dotknięciu"),
                          value: state.chartHapticFeedback,
                          onChanged: (bool value) {
                            context
                                .read<SettingsCubit>()
                                .toggleChartHapticFeedback();
                          },
                          secondary: const Icon(Icons.bolt_rounded),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Motyw",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                            title: const Text("Jasny"),
                            selected: state.themeMode == ThemeMode.light,
                            onTap: () {
                              context
                                  .read<SettingsCubit>()
                                  .setTheme(ThemeMode.light);
                            },
                            leading: const Icon(Icons.light_mode),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                            title: const Text("Ciemny"),
                            leading: const Icon(Icons.dark_mode),
                            selected: state.themeMode == ThemeMode.dark,
                            onTap: () {
                              context
                                  .read<SettingsCubit>()
                                  .setTheme(ThemeMode.dark);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                            title: const Text("System"),
                            leading: const Icon(Icons.auto_awesome),
                            selected: state.themeMode == ThemeMode.system,
                            onTap: () {
                              context
                                  .read<SettingsCubit>()
                                  .setTheme(ThemeMode.system);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ],
                  ),
                ),
                // Column(
                //   children: [
                //     Text("Ikony stworzone przez Freepik z"),
                //     Image.asset(
                //       "lib/assets/img/flaticon.png",
                //       width: 200,
                //     ),
                //   ],
                // )
              ],
            ),
          );
        },
      ),
    );
  }
}
