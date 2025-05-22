class Booking {
  final int id;
  final String status;
  final int userId;
  final int scheduleId;

  Booking({
    required this.id,
    required this.status,
    required this.userId,
    required this.scheduleId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      status: json['status'],
      userId: json['user_id'],
      scheduleId: json['schedule_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'user_id': userId,
      'schedule_id': scheduleId,
    };
  }

  Booking copyWith({
    String? status,
    int? userId,
    int? scheduleId,
  }) {
    return Booking(
      id: id,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      scheduleId: scheduleId ?? this.scheduleId,
    );
  }
}
