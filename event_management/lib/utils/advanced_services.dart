import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class CsvFileGeneratorService {
  static Future<void> exportAndShareMetricsReport(
      List<List<dynamic>> analyticsRawMatrix) async {
    String csvPayloadData =
        const ListToCsvConverter().convert(analyticsRawMatrix);
    final Directory directoryToken = await getTemporaryDirectory();
    final File targetReportFile = File(
        '${directoryToken.path}/Metrics_Report_${DateTime.now().millisecondsSinceEpoch}.csv');
    await targetReportFile.writeAsString(csvPayloadData);
    await Printing.sharePdf(
        bytes: await targetReportFile.readAsBytes(),
        filename: 'Executive_Analytics_Metrics.csv');
  }
}

class AiTranslationService {
  static final modelManager = OnDeviceTranslatorModelManager();

  static Future<String> translateMessage(
      {required String text, required String targetLanguageCode}) async {
    final TranslateLanguage targetLang = TranslateLanguage.values.firstWhere(
      (lang) => lang.bcpCode == targetLanguageCode,
      orElse: () => TranslateLanguage.english,
    );

    final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: targetLang,
    );

    try {
      final bool modelDownloaded =
          await modelManager.isModelDownloaded(targetLang.bcpCode);
      if (!modelDownloaded) {
        await modelManager.downloadModel(targetLang.bcpCode);
      }
      final String translatedText =
          await onDeviceTranslator.translateText(text);
      onDeviceTranslator.close();
      return translatedText;
    } catch (_) {
      onDeviceTranslator.close();
      return text;
    }
  }
}

class EscrowRefundService {
  static Future<bool> initiateTicketRefund(
      {required String ticketId, required String userId}) async {
    final firestore = FirebaseFirestore.instance;
    final ticketRef = firestore.collection('tickets').doc(ticketId);

    try {
      final snapshot = await ticketRef.get();
      if (!snapshot.exists || snapshot.data()?['userId'] != userId)
        return false;
      await ticketRef.update({'status': 'refunded_liquidated'});
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> listTicketForResale(
      {required String ticketId, required double listingPrice}) async {
    await FirebaseFirestore.instance
        .collection('tickets')
        .doc(ticketId)
        .update({
      'status': 'listed_for_resale',
      'resalePrice': listingPrice,
    });
  }
}
