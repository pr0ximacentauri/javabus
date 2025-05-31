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
    required this.province,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      provinceId: json['provinceId'],
      province: json['province'] != null
          ? Province.fromJson(json['province'])
          : null, 
    );
  } 
}