class Bus {
  final int id;
  final String name;

  Bus({required this.id, required this.name});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(id: json['id'], name: json['name']);
  }
}