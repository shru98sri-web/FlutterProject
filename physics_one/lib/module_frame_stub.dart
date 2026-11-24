import 'package:flutter/material.dart';

class ModuleFrame extends StatelessWidget {
  const ModuleFrame({required this.title, required this.moduleUrl, super.key});

  final String title;
  final String moduleUrl;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text('$title is available as a web module at $moduleUrl.'),
    ),
  );
}
