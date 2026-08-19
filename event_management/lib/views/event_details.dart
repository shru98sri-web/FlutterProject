import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pay/pay.dart'; // Handles secure Google Pay token flows
import 'package:qr_flutter/qr_flutter.dart';

import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../utils/hardware_services.dart';
import '../utils/localization.dart';
import 'chat_room_screen.dart';

class EventDetailsScreen extends ConsumerWidget {
  final Event event;
  const EventDetailsScreen({super.key, required this.event});

  /// Triggers automatically when the user approves authorization on the native Google Pay sheet panel
  void _onGooglePaySuccessResult(Map<String, dynamic> resultToken,
      WidgetRef ref, BuildContext context) async {
    debugPrint("Google Pay Token Payload Received: $resultToken");

    final user = ref.read(authProvider).currentUser;
    if (user == null) return;

    final firestore = ref.read(firestoreProvider);
    final ticketDoc = firestore.collection('tickets').doc();
    final payloadToken = 'TICKET-${ticketDoc.id}_EVENT-${event.id}';

    // Commit ticket transaction records securely to the Firestore database
    await ticketDoc.set({
      'ticketId': ticketDoc.id,
      'userId': user.uid,
      'eventId': event.id,
      'eventTitle': event.title,
      'imageUrl': event.imageUrl,
      'bookingTime': DateTime.now(),
      'qrPayload': payloadToken,
      'status': 'active'
    });

    // Fire off asynchronous ecosystem services
    await NotificationService.subscribeToEventChannel(event.id);
    await CalendarSyncService.addEventToNativeCalendar(event);
    await PdfService.generateAndDownloadTicket(event, ticketDoc.id);

    if (context.mounted) {
      _displayPassOverlay(context, payloadToken);
    }
  }

  void _displayPassOverlay(BuildContext context, String payload) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Access Pass Confirmed',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: QrImageView(
                  data: payload, version: QrVersions.auto, size: 180.0),
            ),
            const SizedBox(height: 8),
            const Text(
                'A vector PDF receipt has been shared to your device successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalization.of(context);
    final targetPosition = LatLng(event.latitude, event.longitude);

    // Structure transaction items for the native wallet overlay mapping sheet
    final List<PaymentItem> totalPaymentSummaryItems = [
      PaymentItem(
        label: event.title,
        amount: event.price.toStringAsFixed(2),
        status: PaymentItemStatus.final_price,
      )
    ];

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Header Banner
                ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(event.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover)),
                const SizedBox(height: 16),
                Text(event.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(event.description,
                    style: const TextStyle(fontSize: 15, height: 1.4)),
                const SizedBox(height: 16),

                // Group Chat Interaction Portal
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(double.infinity, 40)),
                  icon: const Icon(Icons.forum_outlined,
                      color: Colors.deepPurple),
                  label: const Text('Enter Live Attendee Chat Room',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChatRoomScreen(
                                eventId: event.id, eventTitle: event.title)));
                  },
                ),
                const SizedBox(height: 20),

                // Adaptive Web/Mobile Fallback Maps Platform View Container
                Container(
                  height: 160,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.3))),
                  child: kIsWeb
                      ? Container(
                          height: 160,
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Text(
                              '📍 Map Sandbox Preview (Optimized for Mobile)'),
                        )
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: targetPosition, zoom: 14.0),
                          markers: {
                            Marker(
                                markerId: const MarkerId('v_mark'),
                                position: targetPosition)
                          },
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                        ),
                ),
                const SizedBox(
                    height: 100), // Prevents layout overlapping with footer
              ],
            ),
          ),

          // Floating Fixed Bottom Action Checkout Footer Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(loc.translate('total_price'),
                          style: const TextStyle(color: Colors.grey)),
                      Text('\$${event.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple)),
                    ],
                  ),

                  // Google Pay Dynamic Button Wrapper featuring FutureBuilder Asset Initialization
                  SizedBox(
                    width: 220,
                    height: 48,
                    child: FutureBuilder<PaymentConfiguration>(
                      future: PaymentConfiguration.fromAsset(
                          'google_pay_config.json'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GooglePayButton(
                            paymentConfiguration: snapshot.data!,
                            paymentItems: totalPaymentSummaryItems,
                            type: GooglePayButtonType.book,
                            margin: const EdgeInsets.only(top: 0.0),
                            onPaymentResult: (result) =>
                                _onGooglePaySuccessResult(result, ref, context),
                            loadingIndicator: const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.deepPurple),
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                              color: Colors.deepPurple),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
