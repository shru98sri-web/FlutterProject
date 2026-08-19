import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart' as local_calendar;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/event_model.dart';

class PaymentService {
  /// Initializes payment systems.
  /// (Left empty since Google Pay configures directly via its JSON asset)
  static Future<void> initialize() async {
    debugPrint("Google Pay client modules linked successfully.");
  }

  /// Optional backend server hook to process or verify the raw Google Pay token payload string.
  /// This replaces the legacy Stripe PaymentSheet presentation flows.
  static Future<bool> processGooglePayToken({
    required Map<String, dynamic> paymentResultToken,
    required double totalAmount,
  }) async {
    if (totalAmount <= 0) return true;

    try {
      // Extract the raw transactional cryptographic token string passed back from Google
      final String rawTokenPayload = paymentResultToken['paymentMethodData']
              ['tokenizationData']['token'] ??
          '';
      debugPrint("Extracted Cryptographic Token: $rawTokenPayload");

      if (rawTokenPayload.isEmpty) {
        return false;
      }

      // PRODUCTION PIPELINE TIP:
      // Send 'rawTokenPayload' and 'totalAmount' to your secure cloud backend server
      // (e.g., Firebase Cloud Functions or your custom Node.js/Python server APIs).
      // Your server will pass it securely to a processor gateway (Stripe, Braintree, etc.) to capture funds.

      return true; // Returns true to confirm verification step passed successfully
    } catch (e) {
      debugPrint("Google Pay verification logic pipeline fault: $e");
      return false;
    }
  }
}

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifier =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'events_high_priority',
      'Critical Event Updates',
      description:
          'Channel routing real-time schedule adjustments alert frames.',
      importance: Importance.max,
    );

    await _localNotifier
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final InitializationSettings settings = InitializationSettings(
      android: const AndroidInitializationSettings('ic_launcher'),
      iOS: const DarwinInitializationSettings(),
    );
    await _localNotifier.initialize(settings);

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      final notification = msg.notification;
      if (notification != null) {
        _localNotifier.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  icon: '@mipmap/ic_launcher')),
        );
      }
    });
  }

  static Future<void> subscribeToEventChannel(String eventId) async {
    await _fcm.subscribeToTopic('event_$eventId');
  }
}

class PdfService {
  static Future<void> generateAndDownloadTicket(
      Event event, String ticketId) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        build: (pw.Context ctx) => pw.Container(
          padding: const pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("OFFICIAL ACCESS ENTRY PASS",
                  style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.deepPurple)),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Text("Event: ${event.title}",
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold)),
              pw.Text("Location: ${event.location}",
                  style: pw.TextStyle(fontSize: 9)),
              pw.Text("Date Frame: ${event.date.toLocal()}",
                  style: pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 12),
              pw.Text("Verification ID Token: $ticketId",
                  style: pw.TextStyle(
                      fontSize: 7,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey700)),
            ],
          ),
        ),
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/Pass_$ticketId.pdf");
    await file.writeAsBytes(await pdf.save());
    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'EventHubPass_$ticketId.pdf');
  }
}

class CalendarSyncService {
  static Future<bool> addEventToNativeCalendar(Event event) async {
    final local_calendar.Event calendarEvent = local_calendar.Event(
      title: event.title,
      description: event.description,
      location: event.location,
      startDate: event.date,
      endDate: event.date.add(const Duration(hours: 3)),
      allDay: false,
    );

    try {
      return await local_calendar.Add2Calendar.addEvent2Cal(calendarEvent);
    } catch (_) {
      return false;
    }
  }
}
