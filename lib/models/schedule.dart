class Schedule {
  final int id;
  final DateTime departureTime;
  final int ticketPrice;
  final int busId;
  final int routeId;

  Schedule({
    required this.id,
    required this.departureTime,
    required this.ticketPrice,
    required this.busId,
    required this.routeId,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      departureTime: DateTime.parse(json['departure_time']),
      ticketPrice: json['ticket_price'],
      busId: json['bus_id'],
      routeId: json['route_id'],
    );
  }
}