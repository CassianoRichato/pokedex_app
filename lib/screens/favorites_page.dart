import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/favorites_service.dart';
import '../widgets/pokemon_tile.dart';

class FavoritesPage extends StatefulWidget {
  final List<Pokemon> allPokemons;

  const FavoritesPage({super.key, required this.allPokemons});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesService _favoritesService = FavoritesService();
  List<int> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favs = await _favoritesService.getFavorites();
    setState(() {
      _favorites = favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritePokemons = widget.allPokemons
        .where((p) => _favorites.contains(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokémons Favoritos')),
      body: favoritePokemons.isEmpty
          ? const Center(
              child: Text(
                'Nenhum Pokémon favoritado ainda 😢',
                style: TextStyle(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: favoritePokemons.length,
              itemBuilder: (_, index) {
                return PokemonTile(pokemon: favoritePokemons[index]);
              },
            ),
    );
  }
}
