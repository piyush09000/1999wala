class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  static String? validateUpiId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a UPI ID';
    }
    // Basic format: something@something
    final RegExp upiRegex = RegExp(r'^[\w.-]+@[\w.-]+$');
    if (!upiRegex.hasMatch(value)) {
      return 'Please enter a valid UPI ID (e.g., example@upi)';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    }
    final double? amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }
}
