class Bus {
  final int? id;
  final String name;
  final String busClass;
  final int totalSeat;

  Bus({
    this.id, 
    required this.name, 
    required this.busClass, 
    required this.totalSeat
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'], 
      name: json['name'],
      busClass: json['busClass'],
      totalSeat: json['totalSeat']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'busClass': busClass,
      'totalSeat': totalSeat,
    };
  }
}