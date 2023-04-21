// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtracker/currency_details/widgets/rates_table.dart';
import 'package:fxtracker/settings/cubit/settings_cubit.dart';
import 'package:intl/intl.dart';

import 'package:fxtracker/models/currency_rate.dart';

class LineChartSample2 extends StatefulWidget {
  final List<Rate> rates;
  final String code;
  const LineChartSample2({
    Key? key,
    required this.rates,
    required this.code,
  }) : super(key: key);

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  late String currentValue;
  late DateTime effectiveDate;
  List<FlSpot> flSpots = [];

  int value = 0;
  int firstDate = 0;
  double percentChange = 0;

  @override
  void initState() {
    currentValue = widget.rates.last.mid.toString();
    effectiveDate = widget.rates.last.effectiveDate;

    DateTime lastDate = effectiveDate.subtract(const Duration(days: 30));

    for (int i = 1; i < widget.rates.length; i++) {
      flSpots.add(FlSpot(i.toDouble(), widget.rates.elementAt(i).mid));
    }
    for (int i = 1; i < widget.rates.length; i++) {
      if (widget.rates.elementAt(i).effectiveDate.isAfter(lastDate)) {
        firstDate = i;

        break;
      }
    }
    percentChange = calculatePercentageChange(flSpots, firstDate);
    super.initState();
  }

  String formatDate(DateTime date) {
    DateFormat formatter = DateFormat(
      'dd/MM/yyyy',
    );
    String formatted = formatter.format(date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    "1 ${widget.code} = $currentValue PLN",
                    textAlign: TextAlign.center,
                  ),
                  Text(formatDate(effectiveDate)),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: percentChange <= 0
                      ? Colors.red.withOpacity(0.95)
                      : Colors.green.withOpacity(0.95),
                ),
                child: Row(
                  children: [
                    Icon(
                      percentChange <= 0
                          ? Icons.trending_down_rounded
                          : Icons.trending_up_rounded,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text("${percentChange.abs().toStringAsFixed(1)}%",
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final bool isCurved = state.isChartCurved;
            final bool chartHapticFeedback = state.chartHapticFeedback;
            return AspectRatio(
              aspectRatio: 1.30,
              child: LineChart(
                swapAnimationDuration:
                    const Duration(milliseconds: 300), // Optional
                swapAnimationCurve: Curves.ease,
                mainData(isCurved, chartHapticFeedback),
              ),
            );
          },
        ),
        buildRangeButtons(),
        RatesTable(rates: widget.rates, code: widget.code, firstDate: firstDate)
      ],
    );
  }

  Widget buildRangeButtons() {
    List<String> range = ["30 d", "60 d", " 90 d", "6 m", "12 m"];
    return SizedBox(
      height: 50,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: range.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: buildRangeChip(range, index),
            );
          },
        ),
      ),
    );
  }

  FilterChip buildRangeChip(List<String> range, int index) {
    return FilterChip(
        showCheckmark: false,
        label: Text(range[index]),
        selected: value == index,
        onSelected: (bool selected) {
          if (value != index) {
            //HapticFeedback.mediumImpact();
            value = index;
            int days = 0;
            switch (index) {
              case 0:
                days = 30;
                break;
              case 1:
                days = 60;
                break;
              case 2:
                days = 90;
                break;
              case 3:
                days = 180;
                break;
              case 4:
                days = 365;
                break;
            }
            DateTime lastDate = effectiveDate.subtract(Duration(days: days));

            for (int i = 1; i < widget.rates.length; i++) {
              if (widget.rates.elementAt(i).effectiveDate.isAfter(lastDate)) {
                firstDate = i;
                percentChange = calculatePercentageChange(flSpots, firstDate);

                break;
              }
            }
            setState(() {});
          }
        });
  }

  LineChartData mainData(bool isCurved, bool chartHapticFeedback) {
    List<Color> gradientColors1 = [
      Colors.red.withOpacity(0.3),
      Colors.red.withOpacity(0.0)
    ];
    List<Color> gradientColors2 = [
      Colors.green.withOpacity(0.3),
      Colors.green.withOpacity(0.0)
    ];
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      clipData: FlClipData.horizontal(),
      minX: firstDate.toDouble(),
      minY: findYMin(flSpots, firstDate),
      maxY: findYMax(flSpots, firstDate),
      lineBarsData: [
        LineChartBarData(
          spots: flSpots,
          isCurved: isCurved,
          barWidth: 3,
          color: percentChange <= 0 ? Colors.red : Colors.green,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: percentChange <= 0 ? gradientColors1 : gradientColors2,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.8, 1],
            ),
          ),
        ),
      ],
      lineTouchData: lineTouchData(chartHapticFeedback),
    );
  }

  LineTouchData lineTouchData(bool chartHapticFeedback) {
    return LineTouchData(
      handleBuiltInTouches: true,
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((spotIndex) {
          return TouchedSpotIndicatorData(
            FlLine(
                color: percentChange <= 0 ? Colors.red : Colors.green,
                strokeWidth: 3,
                dashArray: [4, 3]),
            FlDotData(
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                  strokeWidth: 3,
                  strokeColor: percentChange <= 0 ? Colors.red : Colors.green,
                );
              },
            ),
          );
        }).toList();
      },
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            return null;
          }).toList();
        },
      ),
      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
        if (touchResponse == null ||
            touchResponse.lineBarSpots == null ||
            touchResponse.lineBarSpots!.isEmpty) {
          currentValue = flSpots.last.y.toString();
          effectiveDate = widget.rates.last.effectiveDate;
        } else {
          final day = touchResponse.lineBarSpots!.first.x;
          if (effectiveDate != widget.rates[day.toInt()].effectiveDate) {
            final value = touchResponse.lineBarSpots!.first.y;
            currentValue = value.toString();
            effectiveDate = widget.rates[day.toInt()].effectiveDate;
            if (chartHapticFeedback) {
              HapticFeedback.mediumImpact();
            }
          }
        }
        if (event is FlTapUpEvent || event is FlLongPressEnd) {
          currentValue = flSpots.last.y.toString();
          effectiveDate = widget.rates.last.effectiveDate;
        }

        setState(() {});
      },
    );
  }

  double findYMin(List<FlSpot> flspots, int start) {
    double minY = flspots[start].y;
    for (int i = start; i < flspots.length; i++) {
      if (flspots[i].y < minY) {
        minY = flspots[i].y;
      }
    }
    return minY * 0.995;
  }

  double findYMax(List<FlSpot> flspots, int start) {
    double maxY = flspots[start].y;
    for (int i = start; i < flspots.length; i++) {
      if (flspots[i].y > maxY) {
        maxY = flspots[i].y;
      }
    }
    return maxY * 1.009;
  }

  double calculatePercentageChange(List<FlSpot> flspots, int start) {
    double firstY = flspots[start].y;
    double lastY = flspots.last.y;
    double percentChange = ((lastY - firstY) / firstY) * 100;

    return percentChange;
  }
}
