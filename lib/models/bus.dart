class Bus {
  final int id;
  final String name;
  final String busClass;
  final int totalSeat;

  Bus({
    required this.id, 
    required this.name, 
    required this.busClass, 
    required this.totalSeat
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'], 
      name: json['name'],
      busClass: json['class'],
      totalSeat: json['total_seat']
      );
  }
}