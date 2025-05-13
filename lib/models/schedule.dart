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
      departureTime: DateTime.parse(json['departureTime']),
      ticketPrice: json['ticketPrice'],
      busId: json['busId'],
      routeId: json['routeId'],
    );
  }
}