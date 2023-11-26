class Supplier {
  final String name;
  final String score;
  final String type;
  final String rut;

  Supplier({
    required this.name,
    required this.score,
    required this.type,
    required this.rut,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      name: json['name'],
      score: json['score'],
      type: json['type'],
      rut: json['rut'],
    );
  }

}
