import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/response/DocumentCategory.dart';

class DocumentCategoryChart extends StatelessWidget {
  final List<DocumentCategory?> categories;

  const DocumentCategoryChart({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 260,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 0,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                  sections: _buildSections(),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: _buildLegend(),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final colors = [
      Colors.red.shade700,
      Colors.blue.shade500,
      Colors.purple.shade400,
      Colors.lightBlue.shade300,
      Colors.indigo.shade300,
      Colors.brown.shade400,
    ];

    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: item!.documentCount.toDouble(),
        title: "${item.documentCount}",
        radius: 120,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<Widget> _buildLegend() {
    final colors = [
      Colors.red.shade700,
      Colors.blue.shade500,
      Colors.purple.shade400,
      Colors.lightBlue.shade300,
      Colors.indigo.shade300,
      Colors.brown.shade400,
    ];

    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            color: colors[index % colors.length],
          ),
          const SizedBox(width: 6),
          Text(
            item!.categoryName,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }).toList();
  }
}
