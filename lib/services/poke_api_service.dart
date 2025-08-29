import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokeApiService {
  final String baseUrl = "https://pokeapi.co/api/v2";

  Future<List<Pokemon>> fetchPokemons({int limit = 50, int offset = 0}) async {
    final response = await http.get(
      Uri.parse("$baseUrl/pokemon?limit=$limit&offset=$offset"),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao buscar Pokémons");
    }

    final data = jsonDecode(response.body);
    final List results = data['results'];

    List<Pokemon> pokemons = [];

    for (var item in results) {
      final detailResp = await http.get(Uri.parse(item['url']));
      if (detailResp.statusCode == 200) {
        final detailData = jsonDecode(detailResp.body);
        pokemons.add(Pokemon.fromJson(detailData));
      }
    }

    return pokemons;
  }
}
