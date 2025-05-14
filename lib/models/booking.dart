class Booking {
  final int id;
  final DateTime bookingDate;
  final String status;
  final int userId;
  final int scheduleId;

  Booking({
    required this.id,
    required this.bookingDate,
    required this.status,
    required this.userId,
    required this.scheduleId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      bookingDate: DateTime.parse(json['booking_date']),
      status: json['status'],
      userId: json['userId'],
      scheduleId: json['scheduleId'],
    );
  }
}