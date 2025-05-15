class PaymentRequest {
  final int userId;
  final int scheduleId;
  final int grossAmount;

  PaymentRequest({
    required this.userId,
    required this.scheduleId,
    required this.grossAmount,
  });

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "scheduleId": scheduleId,
        "grossAmount": grossAmount,
      };
}
