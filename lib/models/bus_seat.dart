class BusSeat {
  final int id;
  final int seatNumber;
  final int busId;

  BusSeat({
    required this.id,
    required this.seatNumber,
    required this.busId,
  });

  factory BusSeat.fromJson(Map<String, dynamic> json) {
    return BusSeat(
      id: json['id'],
      seatNumber: json['seatNumber'],
      busId: json['busId'],
    );
  }
}