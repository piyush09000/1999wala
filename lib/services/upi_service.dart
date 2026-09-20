import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpiService {
  /// Generates a UPI intent URI.
  /// Format: upi://pay?pa=merchant@upi&pn=Merchant&am=1999&cu=INR
  static String generateUpiUri(String upiId, double amount, {String merchantName = 'Merchant', String? transactionNote}) {
    final Map<String, String> params = {
      'pa': upiId,
      'pn': merchantName,
      'am': amount.toStringAsFixed(2),
      'cu': 'INR',
    };
    
    if (transactionNote != null && transactionNote.isNotEmpty) {
      params['tn'] = transactionNote;
    }

    final uri = Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: params,
    );

    return uri.toString();
  }

  /// Opens the UPI intent URI in installed apps.
  static Future<bool> launchUpiApp(String upiUri) async {
    final uri = Uri.parse(upiUri);
    try {
      // First try to check if we can launch it
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // sometimes canLaunchUrl returns false but launchUrl works for custom schemes
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch UPI app: $e');
      return false;
    }
  }
}
