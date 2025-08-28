import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokeApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemons({int limit = 50, int offset = 0}) async {
    final url = Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar Pokémons');
    }

    final data = json.decode(response.body);
    final List results = data['results'];

    List<Pokemon> pokemons = [];
    for (var item in results) {
      final detail = await fetchPokemonByName(item['name']);
      if (detail != null) pokemons.add(detail);
    }

    return pokemons;
  }

  Future<Pokemon?> fetchPokemonByName(String name) async {
    final url = Uri.parse('$baseUrl/pokemon/$name');
    final response = await http.get(url);

    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    return Pokemon.fromJson(data);
  }
}
