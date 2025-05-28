class Ticket {
  final int id;
  final int bookingId;
  final int seatId;
  final String qrCodeUrl;
  final DateTime departureTime;
  final String originCity;
  final String destinationCity;
  final String busName;
  final String busClass;
  final int ticketPrice;
  final String ticketStatus;

  Ticket({
    required this.id,
    required this.bookingId,
    required this.seatId,
    required this.qrCodeUrl,
    required this.departureTime,
    required this.originCity,
    required this.destinationCity,
    required this.busName,
    required this.busClass,
    required this.ticketPrice,
    required this.ticketStatus,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      bookingId: json['bookingId'],
      seatId: json['seatId'],
      qrCodeUrl: json['qrCodeUrl'],
      departureTime: DateTime.parse(json['departureTime']),
      originCity: json['originCity'],
      destinationCity: json['destinationCity'],
      busName: json['busName'],
      busClass: json['busClass'],
      ticketPrice: json['ticketPrice'],
      ticketStatus: json['ticketStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ticket': id,
      'booking_id': bookingId,
      'seat_id': seatId,
      'qr_code_url': qrCodeUrl,
      'departure_time': departureTime.toIso8601String(),
      'origin_city': originCity,
      'destination_city': destinationCity,
      'bus_name': busName,
      'bus_class': busClass,
      'ticket_price': ticketPrice,
      'ticket_status': ticketStatus,
    };
  }
}
