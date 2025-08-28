import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/pokemon.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  Color typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellowAccent;
      case 'psychic':
        return Colors.purpleAccent;
      case 'ice':
        return Colors.cyanAccent;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.black54;
      case 'fairy':
        return Colors.pinkAccent;
      case 'ground':
        return Colors.brown;
      case 'rock':
        return Colors.grey;
      case 'fighting':
        return Colors.orange;
      case 'poison':
        return Colors.deepPurple;
      case 'bug':
        return Colors.lightGreen;
      case 'ghost':
        return Colors.deepPurpleAccent;
      case 'steel':
        return Colors.blueGrey;
      case 'flying':
        return Colors.lightBlueAccent;
      default:
        return Colors.grey;
    }
  }

  Widget buildTypeChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pokemon.types
          .map(
            (type) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: typeColor(type),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                type[0].toUpperCase() + type.substring(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget buildAbilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Habilidades',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10,
          children: pokemon.abilities
              .map(
                (ability) => Chip(
                  label: Text(ability[0].toUpperCase() + ability.substring(1)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget buildStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stats',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        ...pokemon.stats.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key[0].toUpperCase() + entry.key.substring(1)),
                Text(entry.value.toString()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(pokemon.displayName),
        backgroundColor: pokemon.types.isNotEmpty
            ? typeColor(pokemon.types.first)
            : Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Hero(
              tag: 'pokemon_${pokemon.id}',
              child: CachedNetworkImage(
                imageUrl: pokemon.imageUrl,
                height: 200,
                fit: BoxFit.contain,
                placeholder: (_, __) => const CircularProgressIndicator(),
                errorWidget: (_, __, ___) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 10),
            buildTypeChips(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildAbilities(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildStats(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
