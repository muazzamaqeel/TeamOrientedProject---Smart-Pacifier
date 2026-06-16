// File: lib/screens/active_monitoring/graphcreation.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphCreation {

  static Widget buildGraphs(
    Map<String, Map<String, Map<String, List<FlSpot>>>> buffers,
    List<Color> palette,
  ) {

    final children = <Widget>[];

    buffers.forEach((sensorType, groups) {

      children.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          sensorType.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
      ));

      final combined = <String, List<FlSpot>>{};
      for (final seriesMap in groups.values) {
        combined.addAll(seriesMap);
      }

      final measurementMap = <String, Map<String, List<FlSpot>>>{};
      combined.forEach((seriesName, spots) {
        String measurement;

        if (sensorType == 'ppg') {
          final match = RegExp(r'^(ID\d+)_(LED1|LED2|LED3|TEMP)$')
              .firstMatch(seriesName);

          if (match != null) {
            measurement = '${match.group(1)!}_PPG';
          } else {
            measurement = 'PPG';
          }
        } else {
          measurement = seriesName.split(RegExp(r'[_\[]')).first;
        }

        measurementMap
            .putIfAbsent(measurement, () => <String, List<FlSpot>>{})[seriesName] =
            spots;
      });

      final measurements = measurementMap.keys.toList()..sort();

      for (final measurement in measurements) {

        final subSeries = measurementMap[measurement]!;

        children.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: _buildChartCard(measurement, subSeries, palette),
        ));
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  static Widget _buildChartCard(
    String title,
    Map<String, List<FlSpot>> seriesMap,
    List<Color> palette,
  ) {

    const double windowSize = 150;

    final rawYs = seriesMap.values.expand((s) => s.map((pt) => pt.y)).toList();

    double meanY = 0, stdY = 0;

    if (rawYs.isNotEmpty) {
      meanY = rawYs.reduce((a, b) => a + b) / rawYs.length;

      final varSum = rawYs
          .map((y) => pow(y - meanY, 2))
          .reduce((a, b) => a + b) /
          rawYs.length;

      stdY = sqrt(varSum);
    }

    final minClip = meanY - 3 * stdY;
    final maxClip = meanY + 3 * stdY;

    final clippedYs = rawYs.map((y) => y.clamp(minClip, maxClip)).toList();

    double minY = clippedYs.isEmpty ? 0 : clippedYs.reduce(min);
    double maxY = clippedYs.isEmpty ? 1 : clippedYs.reduce(max);

    final pad = (maxY - minY) * 0.1;

    final axisMinY = minY - pad;
    final axisMaxY = maxY + pad;

    final allXs = seriesMap.values.expand((s) => s.map((pt) => pt.x));
    final maxX = allXs.isEmpty ? 0.0 : allXs.reduce(max);
    final minX = maxX - windowSize;

    final seriesNames = seriesMap.keys.toList()..sort();

    final bars = <LineChartBarData>[];

    for (var i = 0; i < seriesNames.length; i++) {

      final orig = seriesMap[seriesNames[i]]!;

      final processed = orig
          .where((pt) => pt.x >= minX)
          .map((pt) => FlSpot(pt.x, pt.y.clamp(minClip, maxClip)))
          .toList(growable: false);

      final baseColor = palette[i % palette.length];

      bars.add(LineChartBarData(
        spots: processed,
        isCurved: true,
        curveSmoothness: 0.35,
        barWidth: 3,
        gradient: LinearGradient(
          colors: [
            baseColor,
            baseColor.withOpacity(0.6),
          ],
        ),

        dotData: FlDotData(
          show: true,
          checkToShowDot: (spot, barData) =>
              spot == barData.spots.last,
          getDotPainter: (spot, percent, bar, index) {
            return FlDotCirclePainter(
              radius: 4,
              color: baseColor,
              strokeWidth: 2,
              strokeColor: Colors.white,
            );
          },
        ),

        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              baseColor.withOpacity(0.25),
              baseColor.withOpacity(0.0),
            ],
          ),
        ),
      ));
    }

    final tooltipIndicators = <ShowingTooltipIndicators>[];

    for (var i = 0; i < bars.length; i++) {
      final spots = bars[i].spots;

      if (spots.isNotEmpty) {
        tooltipIndicators.add(
          ShowingTooltipIndicators([
            LineBarSpot(
              bars[i],
              i,
              spots.last,
            )
          ]),
        );
      }
    }

    final legend = Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        for (var i = 0; i < seriesNames.length; i++) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      palette[i % palette.length],
                      palette[i % palette.length].withOpacity(0.6)
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(seriesNames[i],
                  style: const TextStyle(fontSize: 12)),
            ],
          )
        ]
      ],
    );

    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                )),

            const SizedBox(height: 6),

            legend,

            const SizedBox(height: 10),

            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minY: axisMinY,
                  maxY: axisMaxY,
                  lineBarsData: bars,
                  showingTooltipIndicators: tooltipIndicators,
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 30,
                        getTitlesWidget: (value, meta) {

                        final seconds = value.toInt();

                        final duration = Duration(seconds: seconds);

                        final label =
                            "${duration.inHours.toString().padLeft(2, '0')}:"
                            "${(duration.inMinutes % 60).toString().padLeft(2, '0')}:"
                            "${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

                          return Text(
                            label,
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}