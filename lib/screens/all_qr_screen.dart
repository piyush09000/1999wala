import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../models/payment_model.dart';
import '../widgets/qr_card.dart';

class AllQrScreen extends StatelessWidget {
  final List<PaymentModel> payments;

  const AllQrScreen({
    super.key,
    required this.payments,
  });

  void _sharePaymentPlan() {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    
    double total = payments.fold(0, (sum, item) => sum + item.amount);
    
    StringBuffer buffer = StringBuffer();
    buffer.writeln('1999 wala Plan');
    buffer.writeln('Total Amount: ${currencyFormatter.format(total)}');
    buffer.writeln('To: ${payments.first.name} (${payments.first.upiId})\n');
    
    for (var payment in payments) {
      buffer.writeln('Payment ${payment.index}: ${currencyFormatter.format(payment.amount)}');
      buffer.writeln(payment.upiUri);
      buffer.writeln('');
    }
    
    Share.share(buffer.toString());
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('All QR Codes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePaymentPlan,
            tooltip: 'Share Plan',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment ${payment.index}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        currencyFormatter.format(payment.amount),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  QrCard(upiUri: payment.upiUri),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () {
                      Share.share(payment.upiUri);
                    },
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Share Link'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
