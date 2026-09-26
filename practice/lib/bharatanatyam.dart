import 'package:flutter/material.dart';

void main() {
  runApp(const BharatanatyamApp());
}

class BharatanatyamApp extends StatelessWidget {
  const BharatanatyamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bharatanatyam Steps',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFFFFF8F5),
      ),
      home: const StepsDashboard(),
    );
  }
}

class StepsDashboard extends StatelessWidget {
  const StepsDashboard({super.key});

  // Data structure holding Bharatanatyam categories and steps (Adavus)
  final List<Map<String, dynamic>> adavuCategories = const [
    {
      'category': 'Tatta Adavu (Stamping)',
      'description': 'Basic foot striking steps done in Araimandi posture.',
      'steps': [
        {'name': 'First Step', 'rhythm': 'Tha'},
        {'name': 'Second Step', 'rhythm': 'Tha Thei'},
        {'name': 'Third Step', 'rhythm': 'Tha Thei Thei'},
        {'name': 'Fourth Step', 'rhythm': 'Tha Thei Thei Tha'},
      ],
    },
    {
      'category': 'Natta Adavu (Stretching)',
      'description': 'Steps involving stretching the legs on the heel or toes.',
      'steps': [
        {'name': 'First Step', 'rhythm': 'Thei Ya Thei Yi'},
        {'name': 'Second Step', 'rhythm': 'Thei Ya Thei Ya, Thei Yi Thei Yi'},
      ],
    },
    {
      'category': 'Visharu Adavu (Swinging)',
      'description':
          'Steps that involve broad sweeping movements of arms and legs.',
      'steps': [
        {'name': 'First Step', 'rhythm': 'Ta Tai Tai Ta'},
        {'name': 'Second Step', 'rhythm': 'Dhit Tai Tai Ta'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bharatanatyam Adavus',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange[700],
        elevation: 4,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: adavuCategories.length,
        itemBuilder: (context, index) {
          final category = adavuCategories[index];
          return Card(
            margin: const EdgeInsets.all(20.0),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Header
                  Text(
                    category['category'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Category Description
                  Text(
                    category['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Divider(height: 24, thickness: 1),
                  // Steps List under this category
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: category['steps'].length,
                    itemBuilder: (context, stepIndex) {
                      final step = category['steps'][stepIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        key: ValueKey(step['name']),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              step['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.amber[700]!),
                              ),
                              child: Text(
                                step['rhythm'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
