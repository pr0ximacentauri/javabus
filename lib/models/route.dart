class RouteModel {
  final int id;
  final int originCityId;
  final int destinationCityId;

  RouteModel({
    required this.id,
    required this.originCityId,
    required this.destinationCityId,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'],
      originCityId: json['origin_city_id'],
      destinationCityId: json['destination_city_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'origin_city_id': originCityId,
      'destination_city_id': destinationCityId,
    };
  }
}
