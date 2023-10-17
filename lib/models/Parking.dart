class Parking {
  final String id;
  final String name;
  final String state;
  final int emptySpaces;
  bool favorite = false;

  Parking(
      {required this.id,
      required this.name,
      required this.state,
      required this.emptySpaces});

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      name: json['libelle'],
      state: json['etat'],
      emptySpaces: json['dispo'],
    );
  }
}
