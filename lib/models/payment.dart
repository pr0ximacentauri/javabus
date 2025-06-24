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
      id: json['id'], 
      orderId: json['orderId'],
      bookingId: json['bookingId'],
      grossAmount: json['grossAmount'],
      paymentType: json['paymentType'],
      paymentUrl: json['paymentUrl'],
      transactionStatus: json['transactionStatus'],
      transactionTime: DateTime.parse(json['transactionTime']),
    );
  }

}
