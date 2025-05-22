class Ticket {
  final int id;
  final int bookingId;
  final int seatId;
  final String qrCodeUrl;

  Ticket({
    required this.id,
    required this.bookingId,
    required this.seatId,
    required this.qrCodeUrl
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      bookingId: json['booking_id'],
      seatId: json['seat_id'],
      qrCodeUrl: json['qr_code_url']
    );
  }
}