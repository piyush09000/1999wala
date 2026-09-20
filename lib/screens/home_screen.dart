import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../utils/amount_splitter.dart';
import '../models/payment_model.dart';
import '../services/upi_service.dart';
import '../widgets/primary_button.dart';
import 'payment_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _upiController = TextEditingController();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _upiController.dispose();
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _createPaymentPlan() {
    if (_formKey.currentState!.validate()) {
      final double totalAmount = double.parse(_amountController.text);
      final String upiId = _upiController.text.trim();
      final String name = _nameController.text.trim();
      final String reason = _reasonController.text.trim();

      final portions = AmountSplitter.splitAmount(totalAmount);
      
      final List<PaymentModel> payments = [];
      for (int i = 0; i < portions.length; i++) {
        String currentNote = reason;
        if (reason.isNotEmpty && portions.length > 1) {
          currentNote = '$reason (${i + 1}/${portions.length})';
        }
        
        payments.add(
          PaymentModel(
            index: i + 1,
            amount: portions[i],
            upiId: upiId,
            name: name,
            reason: reason,
            upiUri: UpiService.generateUpiUri(
              upiId, 
              portions[i], 
              merchantName: name,
              transactionNote: currentNote,
            ),
          ),
        );
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PaymentPlanScreen(
            totalAmount: totalAmount,
            payments: payments,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1999 wala'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a payment plan',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                
                // Name Input
                Text(
                  'Payee Name',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  keyboardType: TextInputType.name,
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 24),
                
                // UPI ID Input
                Text(
                  'UPI ID',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _upiController,
                  decoration: const InputDecoration(
                    hintText: 'example@upi',
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateUpiId,
                ),
                const SizedBox(height: 24),
                
                // Amount Input
                Text(
                  'Total Amount',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    hintText: 'Enter amount',
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: Validators.validateAmount,
                ),
                const SizedBox(height: 24),
                
                // Reason Input (Optional)
                Text(
                  'Reason for Paying (Optional)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Dinner, Rent',
                    prefixIcon: Icon(Icons.notes),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 48),
                
                // Submit Button
                PrimaryButton(
                  text: 'Create Payment Plan',
                  onPressed: _createPaymentPlan,
                  icon: Icons.auto_awesome,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
