import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/event_provider.dart';
import '../utils/localization.dart';
import 'admin_analytics_panel.dart';
import 'event_details.dart';
import 'profile_screen.dart';
import 'ticket_scanner.dart';

class EventDashboard extends ConsumerWidget {
  const EventDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsStreamProvider);
    final currentCat = ref.watch(selectedCategoryProvider);
    final locale = AppLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.translate('discover'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(Icons.analytics_outlined),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AdminAnalyticsPanel()))),
          IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TicketScannerScreen()))),
          IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()))),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(eventsStreamProvider),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.translate('categories'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _CategoryScroller(currentCat: currentCat),
              const SizedBox(height: 24),
              Text(locale.translate('upcoming'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              eventsAsync.when(
                data: (list) => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (ctx, idx) => _EventCard(event: list[idx]),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text('Data Synchronization Latency: $e')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryScroller extends ConsumerWidget {
  final String currentCat;
  const _CategoryScroller({required this.currentCat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final segments = ['All', 'Technology', 'Food', 'Music', 'Sports'];
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: segments.length,
        itemBuilder: (ctx, idx) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ChoiceChip(
            label: Text(segments[idx]),
            selected: currentCat == segments[idx],
            onSelected: (selected) {
              if (selected)
                ref.read(selectedCategoryProvider.notifier).state =
                    segments[idx];
            },
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final dynamic event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => EventDetailsScreen(event: event))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYy4xqS8w2ehcieBPFpKaXJZDX878iX8ikicknOWwU-Gc21ewM1XDCsXzH&s=10'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(event.location,
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
