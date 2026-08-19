import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../providers/event_provider.dart';

class TicketScannerScreen extends ConsumerStatefulWidget {
  const TicketScannerScreen({super.key});

  @override
  ConsumerState<TicketScannerScreen> createState() =>
      _TicketScannerScreenState();
}

class _TicketScannerScreenState extends ConsumerState<TicketScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _activeScanToken = true;

  void _evaluateScannedToken(String payload) async {
    if (!_activeScanToken) return;
    setState(() => _activeScanToken = false);

    try {
      final docId = payload.split('_').first.replaceAll('TICKET-', '');
      final firestore = ref.read(firestoreProvider);
      final docRef = await firestore.collection('tickets').doc(docId).get();

      if (mounted) {
        if (docRef.exists && docRef.data()?['status'] == 'active') {
          await firestore
              .collection('tickets')
              .doc(docId)
              .update({'status': 'checked_in'});
          _triggerAlertOverlay(
              'Pass Verified', 'Welcome to the venue registry.', Colors.green);
        } else {
          _triggerAlertOverlay('Access Denied',
              'The ticket structural token hash is invalid.', Colors.red);
        }
      }
    } catch (_) {
      _triggerAlertOverlay('Parsing Error',
          'Data formatting structure mismatch.', Colors.orange);
    }
  }

  void _triggerAlertOverlay(String head, String contextBody, Color hue) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(head,
            style: TextStyle(fontWeight: FontWeight.bold, color: hue),
            textAlign: TextAlign.center),
        content: Text(contextBody, textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _activeScanToken = true);
              },
              child: const Text('Reset Scanner Matrix'),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gate Verification Monitor')),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          if (barcode.rawValue != null)
            _evaluateScannedToken(barcode.rawValue!);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
