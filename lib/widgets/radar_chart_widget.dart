import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';

class RadarChartWidget extends StatelessWidget {
  final Map<Category, int> scaledScores;

  const RadarChartWidget({super.key, required this.scaledScores});

  @override
  Widget build(BuildContext context) {
    // Orders must match: identity, target, visual, trust
    final scores = [
      scaledScores[Category.identity]!.toDouble(),
      scaledScores[Category.target]!.toDouble(),
      scaledScores[Category.visual]!.toDouble(),
      scaledScores[Category.trust]!.toDouble(),
    ];

    return AspectRatio(
      aspectRatio: 1.2,
      child: RadarChart(
        RadarChartData(
          radarTouchData: RadarTouchData(enabled: false),
          dataSets: [
            RadarDataSet(
              fillColor: AppTheme.primaryColor.withOpacity(0.3),
              borderColor: AppTheme.secondaryColor,
              entryRadius: 3,
              dataEntries: scores.map((e) => RadarEntry(value: e)).toList(),
              borderWidth: 2,
            ),
          ],
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.transparent),
          tickCount: 5,
          ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
          tickBorderData: const BorderSide(color: Colors.black12),
          gridBorderData: const BorderSide(color: Colors.black12, width: 2),
          getTitle: (index, angle) {
            String text = '';
            switch (index) {
              case 0: text = '정체성'; break;
              case 1: text = '고객'; break;
              case 2: text = '첫인상'; break;
              case 3: text = '신뢰감'; break;
            }
            return RadarChartTitle(
              text: text,
              angle: 0,
              positionPercentageOffset: 0.2,
            );
          },
          radarShape: RadarShape.polygon,
        ),
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      ),
    );
  }
}
