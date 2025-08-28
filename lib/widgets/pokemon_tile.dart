import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/pokemon.dart';

class PokemonTile extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonTile({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'pokemon_${pokemon.id}',
            child: CachedNetworkImage(
              imageUrl: pokemon.imageUrl,
              height: 150,
              width: 150,
              fit: BoxFit.contain,
              placeholder: (_, __) => const CircularProgressIndicator(),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '#${pokemon.id}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(pokemon.displayName, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
