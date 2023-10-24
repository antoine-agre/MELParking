import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("favorites")) {
      List<String> favoritesList = prefs.getStringList("favorites")!;
      if (favorite) {
        favoritesList.remove(id);
      } else {
        if (!favoritesList.contains(id)) {
          favoritesList.add(id);
        }
      }
      prefs.setStringList("favorites", favoritesList);
    } else {
      if (!favorite) {
        prefs.setStringList("favorites", [id]);
      }
    }

    favorite = !favorite;
  }
}
