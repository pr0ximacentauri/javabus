import 'package:javabus/models/province.dart';

class City {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int provinceId;
  final Province? province;

  City({
    required this.id,
    required this.name,
    required this.latitude, 
    required this.longitude,
    required this.provinceId,
    this.province,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      provinceId: json['provinceId'],
      province: json['province'] != null
          ? Province.fromJson(json['province'])
          : null, 
    );
  } 
}