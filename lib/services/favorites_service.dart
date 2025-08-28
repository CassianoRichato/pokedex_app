import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String keyFavorites = 'favorites';

  Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favs = prefs.getStringList(keyFavorites);
    if (favs == null) return [];
    return favs
        .map((e) {
          try {
            return int.parse(e);
          } catch (_) {
            return -1;
          }
        })
        .where((e) => e != -1)
        .toList();
  }

  Future<void> toggleFavorite(int pokemonId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (favorites.contains(pokemonId)) {
      favorites.remove(pokemonId);
    } else {
      favorites.add(pokemonId);
    }
    await prefs.setStringList(
      keyFavorites,
      favorites.map((e) => e.toString()).toList(),
    );
  }

  Future<bool> isFavorite(int pokemonId) async {
    final favorites = await getFavorites();
    return favorites.contains(pokemonId);
  }
}
