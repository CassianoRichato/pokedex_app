import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/poke_api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/pokemon_tile.dart';
import 'pokemon_detail_screen.dart';
import 'favorites_page.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokeApiService apiService = PokeApiService();
  final FavoritesService favoritesService = FavoritesService();
  final ScrollController _scrollController = ScrollController();

  List<Pokemon> pokemons = [];
  List<Pokemon> filteredPokemons = [];
  bool isLoading = false;
  bool hasError = false;
  int offset = 0;
  final int limit = 50;
  bool allLoaded = false;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    loadPokemons();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          !allLoaded &&
          !isSearching) {
        loadPokemons();
      }
    });
  }

  Future<void> loadPokemons() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await apiService.fetchPokemons(limit: limit, offset: offset);

      if (data.isEmpty) {
        allLoaded = true;
      } else {
        offset += limit;
        pokemons.addAll(data);
        filteredPokemons = pokemons;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void searchPokemon(String query) {
    query = query.toLowerCase().trim();

    if (query.isEmpty) {
      setState(() {
        filteredPokemons = pokemons;
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
      filteredPokemons = pokemons
          .where((p) => p.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokédex"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FavoritesPage(favoritesService: favoritesService),
                ),
              );
            },
          ),
        ],
      ),
      body: hasError
          ? const Center(child: Text("Erro ao carregar Pokémons"))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar Pokémon...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: searchPokemon,
                  ),
                ),
                Expanded(
                  child: filteredPokemons.isEmpty
                      ? const Center(child: Text("Nenhum Pokémon encontrado"))
                      : GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: filteredPokemons.length,
                          itemBuilder: (context, index) {
                            final pokemon = filteredPokemons[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PokemonDetailScreen(pokemon: pokemon),
                                  ),
                                );
                              },
                              child: PokemonTile(
                                pokemon: pokemon,
                                favoritesService: favoritesService,
                              ),
                            );
                          },
                        ),
                ),
                if (isLoading && !isSearching)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}
