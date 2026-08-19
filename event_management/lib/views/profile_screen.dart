import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/event_provider.dart';
import '../utils/advanced_services.dart';
import '../utils/localization.dart';
import '../utils/theme_config.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).currentUser;
    final firestore = ref.watch(firestoreProvider);
    final activeThemeMode = ref.watch(themeModeProvider);
    final activeLang = ref.watch(currentLanguageProvider);
    final loc = AppLocalization.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('profile'))),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                    radius: 44,
                    backgroundImage:
                        NetworkImage(user?.photoURL ?? 'https://placehold.co')),
                const SizedBox(height: 12),
                Text(user?.displayName ?? 'Operator Attendant',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(loc.translate('dark_mode')),
            trailing: Switch(
              value: activeThemeMode == ThemeMode.dark,
              onChanged: (val) => ref.read(themeModeProvider.notifier).state =
                  val ? ThemeMode.dark : ThemeMode.light,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: const Text('System Interface Language'),
            trailing: DropdownButton<String>(
              value: activeLang.languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English (EN)')),
                DropdownMenuItem(value: 'es', child: Text('Español (ES)')),
              ],
              onChanged: (langCode) {
                if (langCode != null)
                  ref.read(currentLanguageProvider.notifier).state =
                      Locale(langCode);
              },
            ),
          ),
          const Divider(),
          const SizedBox(height: 12),
          Text(loc.translate('history'),
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('tickets')
                .where('userId', isEqualTo: user?.uid)
                .snapshots(),
            builder: (ctx, snap) {
              if (!snap.hasData)
                return const Center(child: CircularProgressIndicator());
              final docs = snap.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (ctx, idx) {
                  final item = docs[idx].data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(item['eventTitle'] ?? 'Event Pass Entry'),
                    subtitle: Text('ID Code Token: ${item['ticketId']}',
                        style: const TextStyle(fontSize: 11)),
                    trailing: item['status'] == 'active'
                        ? TextButton(
                            child: const Text('Resell Pass',
                                style: TextStyle(color: Colors.deepPurple)),
                            onPressed: () async {
                              await EscrowRefundService.listTicketForResale(
                                  ticketId: item['ticketId'],
                                  listingPrice: 40.0);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Ticket listed on the exchange.')));
                            },
                          )
                        : Text('Status: ${item['status']}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
