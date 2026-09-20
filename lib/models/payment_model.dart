class PaymentModel {
  final int index;
  final double amount;
  final String upiId;
  final String name;
  final String? reason;
  final String upiUri;

  PaymentModel({
    required this.index,
    required this.amount,
    required this.upiId,
    required this.name,
    this.reason,
    required this.upiUri,
  });
}
