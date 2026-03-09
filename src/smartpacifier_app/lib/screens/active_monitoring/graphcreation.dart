// File: lib/screens/active_monitoring/graphcreation.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphCreation {
  /// [buffers]: sensorType → groupName → seriesName → spots
  /// [palette]: list of colors to cycle through
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
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ));

      final combined = <String, List<FlSpot>>{};
      for (final seriesMap in groups.values) {
        combined.addAll(seriesMap);
      }

      final measurementMap = <String, Map<String, List<FlSpot>>>{};
      combined.forEach((seriesName, spots) {
        final measurement = seriesName.split(RegExp(r'[_\[]')).first;
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
    // 1) Collect & clamp Y values for auto-scaling
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
    final minClip = meanY - 3 * stdY, maxClip = meanY + 3 * stdY;
    final clippedYs = rawYs.map((y) => y.clamp(minClip, maxClip)).toList();
    double minY = clippedYs.isEmpty ? 0 : clippedYs.reduce(min);
    double maxY = clippedYs.isEmpty ? 1 : clippedYs.reduce(max);
    final pad = (maxY - minY) * 0.05;
    final axisMinY = minY - pad, axisMaxY = maxY + pad;

    // 2) Invert X-axis if desired
    final allXs = seriesMap.values.expand((s) => s.map((pt) => pt.x));
    final maxX = allXs.isEmpty ? 0.0 : allXs.reduce(max);

    // 3) Build each LineChartBarData
    final seriesNames = seriesMap.keys.toList()..sort();
    final bars = <LineChartBarData>[];

    for (var i = 0; i < seriesNames.length; i++) {
      final orig = seriesMap[seriesNames[i]]!;
      final processed = orig
          .map((pt) => FlSpot(maxX - pt.x, pt.y.clamp(minClip, maxClip)))
          .toList(growable: false);

      bars.add(LineChartBarData(
        spots: processed,
        isCurved: true,
        curveSmoothness: 0.2,
        color: palette[i % palette.length],
        barWidth: 2.5,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              palette[i % palette.length].withOpacity(0.3),
              palette[i % palette.length].withOpacity(0.0),
            ],
          ),
        ),
      ));
    }

    // 4) Legend
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
                  color: palette[i % palette.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(seriesNames[i], style: const TextStyle(fontSize: 12)),
            ],
          )
        ]
      ],
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            legend,
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  minY: axisMinY,
                  maxY: axisMaxY,
                  lineBarsData: bars,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    getDrawingVerticalLine: (_) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),

                  // --- Corrected Tooltip Configuration ---
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.black87,
                      tooltipBorderRadius: BorderRadius.circular(6),
                      tooltipPadding: const EdgeInsets.all(6),
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          final name = seriesNames[spot.barIndex];
                          final y = spot.y.toStringAsFixed(3);
                          return LineTooltipItem(
                            '$name: $y',
                            TextStyle(
                              color: spot.bar.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
