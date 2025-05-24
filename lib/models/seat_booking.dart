class SeatBooking{
  final int id;
  final int bookingId;
  final int scheduleId;
  final int seatId;

  SeatBooking({required this.id, required this.bookingId, required this.scheduleId, required this.seatId});

  factory SeatBooking.fromJson(Map<String, dynamic> json) {
    return SeatBooking(
      id: json['id'],
      bookingId: json['bookingId'],
      scheduleId: json['scheduleId'],
      seatId: json['seatId'],
    );
  }
}