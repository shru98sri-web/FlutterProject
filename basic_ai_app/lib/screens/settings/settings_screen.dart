import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/prediction_service.dart';
import '../../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool serverHealthy = false;
  bool checking = false;

  Future<void> checkServer() async {
    setState(() {
      checking = true;
    });

    final service = PredictionService(
      apiService: ApiService(
        baseUrl: AppConstants.baseUrl,
      ),
    );

    final result = await service.checkHealth();

    setState(() {
      serverHealthy = result;
      checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.cloud,
                  ),
                  title: const Text(
                    'FastAPI Server',
                  ),
                  subtitle: Text(
                    AppConstants.baseUrl,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    serverHealthy ? Icons.check_circle : Icons.cloud_off,
                  ),
                  title: Text(
                    checking
                        ? 'Checking...'
                        : serverHealthy
                            ? 'Server Connected'
                            : 'Server Not Checked',
                  ),
                  trailing: checking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : FilledButton(
                          onPressed: checkServer,
                          child: const Text(
                            'TEST',
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(
                    Icons.dark_mode,
                  ),
                  title: const Text(
                    'Dark Mode',
                  ),
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });

                    // This screen maintains the
                    // setting locally. For global
                    // theme persistence, connect
                    // this to your app state.
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    'Application',
                  ),
                  subtitle: Text(
                    'AI Customer Intelligence',
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.code,
                  ),
                  title: Text(
                    'Architecture',
                  ),
                  subtitle: Text(
                    'Flutter + FastAPI + ML',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
