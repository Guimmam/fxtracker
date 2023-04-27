import 'package:flutter/material.dart';

class PercentageChange extends StatelessWidget {
  const PercentageChange({
    super.key,
    required this.percentChange,
  });

  final double percentChange;

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
