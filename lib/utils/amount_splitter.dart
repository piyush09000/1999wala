class AmountSplitter {
  static const double splitPortion = 1999.0;

  /// Splits a total amount into as many 1999 portions as possible,
  /// with the final portion containing the remainder (if any).
  static List<double> splitAmount(double totalAmount) {
    if (totalAmount <= 0) return [];
    
    if (totalAmount <= splitPortion) {
      return [totalAmount];
    }

    List<double> portions = [];
    double remaining = totalAmount;

    while (remaining > splitPortion) {
      portions.add(splitPortion);
      remaining -= splitPortion;
    }
    
    // Using simple rounding to avoid floating point precision issues like 1002.00000000001
    remaining = double.parse(remaining.toStringAsFixed(2));

    if (remaining > 0) {
      portions.add(remaining);
    }

    return portions;
  }
}
