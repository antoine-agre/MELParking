class Parking {
  final String name;
  final String state;
  final int emptySpaces;

  const Parking(
      {required this.name, required this.state, required this.emptySpaces});

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      name: json['libelle'],
      state: json['etat'],
      emptySpaces: json['dispo'],
    );
  }
}
