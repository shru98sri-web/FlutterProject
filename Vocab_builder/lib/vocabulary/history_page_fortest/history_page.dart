// ============================================================
// HISTORY
// ============================================================

import 'package:flutter/material.dart';

import '../test/test_models/test_models.dart';

class HistoryPage extends StatelessWidget {
  final List<AssessmentRecord> history;

  const HistoryPage({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assessment History',
        ),
      ),
      body: history.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 60,
                    color: Colors.white38,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No assessments yet.',
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Complete a test to create history.',
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: history.length,
              itemBuilder: (_, index) {
                final item = history[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        '${item.score}',
                      ),
                    ),
                    title: Text(
                      '${item.percentage.toStringAsFixed(1)}% • ${item.level}',
                    ),
                    subtitle: Text(
                      '${item.date.day}/${item.date.month}/${item.date.year}'
                      ' • Avg ${item.averageTime.toStringAsFixed(1)}s',
                    ),
                    trailing: item.voiceScore > 0
                        ? Text(
                            'Voice ${item.voiceScore}',
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
