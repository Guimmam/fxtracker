// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class LineChartSample2 extends StatefulWidget {
  List<FlSpot> flSpots;
  List<DateTime> days;
  String code;
  LineChartSample2({
    Key? key,
    required this.flSpots,
    required this.days,
    required this.code,
  }) : super(key: key);

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [Color.fromRGBO(0, 188, 212, 1), Colors.green];
  late String currentValue;
  late DateTime effectiveDate;

  @override
  void initState() {
    currentValue = widget.flSpots.last.y.toString();
    effectiveDate = widget.days.last;
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
        Text(
          "1 ${widget.code} = $currentValue PLN",
          textAlign: TextAlign.center,
        ),
        Text(formatDate(effectiveDate)),
        AspectRatio(
          aspectRatio: 1.30,
          child: LineChart(
            mainData(),
          ),
        ),
        ActionChoiceExample()
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          ))),
      borderData: FlBorderData(
        show: false,
      ),
      minY: findYMin(widget.flSpots),
      maxY: findYMax(widget.flSpots),
      lineBarsData: [
        LineChartBarData(
          spots: widget.flSpots,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            final spot = barData.spots[spotIndex];

            return TouchedSpotIndicatorData(
              FlLine(color: Colors.green, strokeWidth: 3, dashArray: [4, 3]),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: Colors.black.withOpacity(0.7),
                  );
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          fitInsideHorizontally: true,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              if (touchedSpot.y == findYMin(widget.flSpots)) {
                return LineTooltipItem(
                  touchedSpot.y.toString(),
                  const TextStyle(color: Colors.white),
                );
              } else {
                return null;
              }
            }).toList();
          },
        ),
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          if (touchResponse == null) {
            setState(() {
              currentValue = widget.flSpots.last.y.toString();
              effectiveDate = widget.days.last;
            });
          } else if (touchResponse.lineBarSpots != null &&
              touchResponse.lineBarSpots!.isNotEmpty) {
            final value = touchResponse.lineBarSpots!.first.y;
            final day = touchResponse.lineBarSpots!.first.x;
            setState(() {
              currentValue = value.toString();
              effectiveDate = widget.days[day.toInt()];
            });
          } else {
            setState(() {
              currentValue = widget.flSpots.last.y.toString();
              effectiveDate = widget.days.last;
            });
          }
          if (event is FlTapUpEvent || event is FlLongPressEnd) {
            setState(() {
              currentValue = widget.flSpots.last.y.toString();
              effectiveDate = widget.days.last;
            });
          }
        },
      ),
    );
  }

  double findYMin(List<FlSpot> flspots) {
    double minY = flspots[0].y;
    for (FlSpot spot in flspots) {
      if (spot.y < minY) {
        minY = spot.y;
      }
    }
    return minY * 0.995;
  }

  double findYMax(List<FlSpot> flspots) {
    double maxY = flspots[0].y;
    for (FlSpot spot in flspots) {
      if (spot.y > maxY) {
        maxY = spot.y;
      }
    }
    return maxY * 1.009;
  }
}

class ActionChoiceExample extends StatefulWidget {
  const ActionChoiceExample({super.key});

  @override
  State<ActionChoiceExample> createState() => _ActionChoiceExampleState();
}

class _ActionChoiceExampleState extends State<ActionChoiceExample> {
  int? _value = 1;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Wrap(
            spacing: 5.0,
            children: List<Widget>.generate(
              3,
              (int index) {
                return FilterChip(
                  label: Text('Item $index'),
                  selected: _value == index,
                  onSelected: (bool selected) {
                    setState(() {
                      _value = selected ? index : null;
                    });
                  },
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
