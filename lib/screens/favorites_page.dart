import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../widgets/pokemon_tile.dart';
import '../services/favorites_service.dart';
import 'pokemon_detail_screen.dart';

class FavoritesPage extends StatefulWidget {
  final FavoritesService favoritesService;

  const FavoritesPage({super.key, required this.favoritesService});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<int> favoriteIds = [];
  List<Pokemon> favoritePokemons = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    favoriteIds = await widget.favoritesService.getFavorites();
    setState(() {
      // favoritePokemons devem ser filtrados do seu repositório principal de pokemons
      // Supondo que você tenha uma lista global ou a envie para cá
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokémons Favoritos")),
      body: favoritePokemons.isEmpty
          ? const Center(child: Text("Nenhum Pokémon favoritado"))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: favoritePokemons.length,
              itemBuilder: (context, index) {
                final pokemon = favoritePokemons[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PokemonDetailScreen(pokemon: pokemon),
                      ),
                    );
                  },
                  child: PokemonTile(
                    pokemon: pokemon,
                    favoritesService: widget.favoritesService,
                  ),
                );
              },
            ),
    );
  }
}
