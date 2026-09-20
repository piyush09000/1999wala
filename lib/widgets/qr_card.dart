import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QrCard extends StatelessWidget {
  final String upiUri;
  final ScreenshotController? screenshotController;

  const QrCard({
    super.key,
    required this.upiUri,
    this.screenshotController,
  });

  @override
  Widget build(BuildContext context) {
    final qrWidget = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: upiUri,
            version: QrVersions.auto,
            size: 250.0,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Scan to Pay',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );

    if (screenshotController != null) {
      return Screenshot(
        controller: screenshotController!,
        child: qrWidget,
      );
    }

    return qrWidget;
  }
}
