// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  List<FlSpot> flSpots;
  String code;
  LineChartSample2({
    Key? key,
    required this.flSpots,
    required this.code,
  }) : super(key: key);

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [Color.fromRGBO(0, 188, 212, 1), Colors.green];
  late String currentValue;

  @override
  void initState() {
    currentValue = widget.flSpots.last.y.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "1 ${widget.code} = $currentValue PLN",
          textAlign: TextAlign.center,
        ),
        AspectRatio(
          aspectRatio: 1.30,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
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
      ),
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
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          fitInsideHorizontally: true,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              return LineTooltipItem(
                touchedSpot.y.toString(),
                const TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          if (touchResponse == null) {
            setState(() {
              currentValue = widget.flSpots.last.y.toString();
            });
          } else if (touchResponse.lineBarSpots != null &&
              touchResponse.lineBarSpots!.isNotEmpty) {
            final value = touchResponse.lineBarSpots!.first.y;
            setState(() {
              currentValue = value.toString();
            });
          } else {
            setState(() {
              currentValue = widget.flSpots.last.y.toString();
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
