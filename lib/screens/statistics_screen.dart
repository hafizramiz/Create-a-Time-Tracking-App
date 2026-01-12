import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../provider/time_entry_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: const Color(0xFF458B7D),
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          final grouped = provider.groupedEntries;
          if (grouped.isEmpty) {
            return const Center(child: Text('No entries to visualize.'));
          }

          double totalOverall = 0;
          for (var entries in grouped.values) {
            for (var entry in entries) {
              totalOverall += entry.totalTime;
            }
          }

          final colors = [
            Colors.teal,
            Colors.purple,
            Colors.orange,
            Colors.blue,
            Colors.red,
            Colors.green,
          ];

          int colorIndex = 0;
          final sections = grouped.entries.map((group) {
            double totalForProject = 0;
            for (var entry in group.value) {
              totalForProject += entry.totalTime;
            }

            final color = colors[colorIndex % colors.length];
            colorIndex++;

            return PieChartSectionData(
              value: totalForProject,
              title:
                  '${group.key}\n${((totalForProject / totalOverall) * 100).toStringAsFixed(1)}%',
              color: color,
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Time Distribution by Project',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
