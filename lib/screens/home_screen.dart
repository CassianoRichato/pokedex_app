import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/poke_api_service.dart';
import '../widgets/pokemon_tile.dart';
import 'pokemon_detail_screen.dart';
import 'favorites_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokeApiService apiService = PokeApiService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

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
      final atBottom =
          _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200;

      if (atBottom && !isLoading && !allLoaded && !isSearching) {
        loadPokemons();
      }
    });
  }

  Future<void> loadPokemons() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final data = await apiService.fetchPokemons(limit: limit, offset: offset);

      if (!mounted) return;

      if (data.isEmpty) {
        allLoaded = true;
      } else {
        offset += limit;
        pokemons.addAll(data);
        if (!isSearching) {
          filteredPokemons = List<Pokemon>.from(pokemons);
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void searchPokemon(String raw) {
    final query = raw.toLowerCase().trim();

    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredPokemons = List<Pokemon>.from(pokemons);
      });
      return;
    }

    final results = pokemons
        .where((p) => p.name.toLowerCase().contains(query))
        .toList(growable: false);

    setState(() {
      isSearching = true;
      filteredPokemons = results;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildInitialLoaderOrContent() {
    if (isLoading && pokemons.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError && pokemons.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Erro ao carregar Pokémons'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: loadPokemons,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (filteredPokemons.isEmpty) {
      return const Center(child: Text('Nenhum Pokémon encontrado'));
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
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
                builder: (_) => PokemonDetailScreen(pokemon: pokemon),
              ),
            );
          },
          child: PokemonTile(
            pokemon: pokemon,
            // se seu PokemonTile expõe um callback quando favoritar, dá pra atualizar a tela:
            // onFavoriteToggled: () => setState(() {}),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final showBottomLoader = isLoading && !isSearching && pokemons.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Favoritos',
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesPage(allPokemons: pokemons),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Busca
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar Pokémon...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: isSearching
                    ? IconButton(
                        tooltip: 'Limpar busca',
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          searchPokemon('');
                        },
                      )
                    : null,
              ),
              onChanged: searchPokemon,
              textInputAction: TextInputAction.search,
            ),
          ),

          // Lista / estados
          Expanded(child: _buildInitialLoaderOrContent()),

          // Loader de "carregando mais" (paginação)
          if (showBottomLoader)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
