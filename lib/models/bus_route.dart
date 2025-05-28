class BusRoute {
  final int id;
  final int originCityId;
  final int destinationCityId;

  BusRoute({
    required this.id,
    required this.originCityId,
    required this.destinationCityId,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      id: json['id'],
      originCityId: json['originCityId'],
      destinationCityId: json['destinationCityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originCityId': originCityId,
      'destinationCityId': destinationCityId,
    };
  }
}
