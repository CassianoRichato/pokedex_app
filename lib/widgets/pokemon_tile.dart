import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/pokemon.dart';
import '../services/favorites_service.dart';

class PokemonTile extends StatefulWidget {
  final Pokemon pokemon;
  final FavoritesService favoritesService;

  const PokemonTile({
    super.key,
    required this.pokemon,
    required this.favoritesService,
  });

  @override
  State<PokemonTile> createState() => _PokemonTileState();
}

class _PokemonTileState extends State<PokemonTile> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

  Future<void> checkFavorite() async {
    final fav = await widget.favoritesService.isFavorite(widget.pokemon.id);
    setState(() {
      isFavorite = fav;
    });
  }

  void toggleFavorite() async {
    await widget.favoritesService.toggleFavorite(widget.pokemon.id);
    final fav = await widget.favoritesService.isFavorite(widget.pokemon.id);
    setState(() {
      isFavorite = fav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Stack(
        children: [
          Column(
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
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: toggleFavorite,
            ),
          ),
        ],
      ),
    );
  }
}
