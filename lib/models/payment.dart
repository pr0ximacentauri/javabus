class Payment {
  final int id;
  final String orderId;
  final int bookingId;
  final int grossAmount;
  final String paymentType;
  final String paymentUrl;
  final String transactionStatus;
  final DateTime transactionTime;

  Payment({
    required this.id,
    required this.orderId,
    required this.bookingId,
    required this.grossAmount,
    required this.paymentType,
    required this.paymentUrl,
    required this.transactionStatus,
    required this.transactionTime,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id_payment'],
      orderId: json['id_order'],
      bookingId: json['booking_id'],
      grossAmount: json['gross_amount'],
      paymentType: json['payment_type'],
      paymentUrl: json['payment_url'],
      transactionStatus: json['transaction_status'],
      transactionTime: DateTime.parse(json['transaction_time']),
    );
  }
}
