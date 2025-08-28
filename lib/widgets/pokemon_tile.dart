import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/pokemon.dart';
import '../services/favorites_service.dart';

class PokemonTile extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonTile({super.key, required this.pokemon});

  @override
  State<PokemonTile> createState() => _PokemonTileState();
}

class _PokemonTileState extends State<PokemonTile> {
  final FavoritesService _favoritesService = FavoritesService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    bool fav = await _favoritesService.isFavorite(widget.pokemon.id);
    setState(() {
      _isFavorite = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    await _favoritesService.toggleFavorite(widget.pokemon.id);
    _loadFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'pokemon_${widget.pokemon.id}',
            child: CachedNetworkImage(
              imageUrl: widget.pokemon.imageUrl,
              height: 120,
              width: 120,
              fit: BoxFit.contain,
              placeholder: (_, __) => const CircularProgressIndicator(),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '#${widget.pokemon.id}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            widget.pokemon.displayName,
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
    );
  }
}
