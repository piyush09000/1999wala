import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/payment_model.dart';
import '../widgets/qr_card.dart';
import '../services/upi_service.dart';

class QrPaymentScreen extends StatefulWidget {
  final List<PaymentModel> payments;
  final int initialIndex;

  const QrPaymentScreen({
    super.key,
    required this.payments,
    this.initialIndex = 0,
  });

  @override
  State<QrPaymentScreen> createState() => _QrPaymentScreenState();
}

class _QrPaymentScreenState extends State<QrPaymentScreen> {
  late PageController _pageController;
  late int _currentIndex;
  late List<ScreenshotController> _screenshotControllers;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _screenshotControllers = List.generate(
      widget.payments.length,
      (_) => ScreenshotController(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _shareQr(PaymentModel payment, int index) async {
    try {
      final image = await _screenshotControllers[index].capture();
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/payment_${payment.index}.png').create();
        await imagePath.writeAsBytes(image);
        
        await Share.shareXFiles(
          [XFile(imagePath.path)],
          text: 'Payment ${payment.index} of ${widget.payments.length}\nAmount: ₹${payment.amount}\nTo: ${payment.name} (${payment.upiId})',
        );
      }
    } catch (e) {
      debugPrint('Error sharing QR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to share QR code')),
        );
      }
    }
  }

  Future<void> _openUpiApp(PaymentModel payment) async {
    final success = await UpiService.launchUpiApp(payment.upiUri);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No supported UPI app found. Please scan the QR.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Payment ${_currentIndex + 1} of ${widget.payments.length}'),
      ),
      body: Column(
        children: [
          // Page Indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.payments.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.payments.length,
              itemBuilder: (context, index) {
                final payment = widget.payments[index];
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currencyFormatter.format(payment.amount),
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'To: ${payment.name} (${payment.upiId})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 32),
                      QrCard(
                        upiUri: payment.upiUri,
                        screenshotController: _screenshotControllers[index],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _shareQr(widget.payments[_currentIndex], _currentIndex),
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Share QR'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openUpiApp(widget.payments[_currentIndex]),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Open UPI App'),
                      ),
                    ),
                  ],
                ),
                if (_currentIndex < widget.payments.length - 1) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Next Payment'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
