class Payment {
  final int id;
  final int bookingId;
  final String orderId;
  final int grossAmount;
  final String paymentType;
  final String paymentUrl;
  final String transactionStatus;
  final DateTime transactionTime;

  Payment({
    required this.id,
    required this.bookingId,
    required this.orderId,
    required this.grossAmount,
    required this.paymentType,
    required this.paymentUrl,
    required this.transactionStatus,
    required this.transactionTime,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id_payment'],
      bookingId: json['fk_booking'],
      orderId: json['id_order'],
      grossAmount: json['gross_amount'],
      paymentType: json['payment_type'],
      paymentUrl: json['payment_url'],
      transactionStatus: json['transaction_status'],
      transactionTime: DateTime.parse(json['transaction_time']),
    );
  }
}
