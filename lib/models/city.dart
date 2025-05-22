import 'package:javabus/models/province.dart';

class City {
  final int id;
  final String name;
  final int provinceId;
  final Province? province;

  City({
    required this.id,
    required this.name,
    required this.provinceId,
    required this.province,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      provinceId: json['province_id'],
      province: json['province'] != null
          ? Province.fromJson(json['province'])
          : null, 
    );
  } 
}