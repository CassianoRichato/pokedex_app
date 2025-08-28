class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.types = const [],
    this.abilities = const [],
    this.stats = const {},
  });

  String get displayName => name[0].toUpperCase() + name.substring(1);

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default'] ?? '',
      types:
          (json['types'] as List<dynamic>?)
              ?.map((t) => t['type']['name'] as String)
              .toList() ??
          [],
      abilities:
          (json['abilities'] as List<dynamic>?)
              ?.map((a) => a['ability']['name'] as String)
              .toList() ??
          [],
      stats: Map.fromEntries(
        (json['stats'] as List<dynamic>?)?.map(
              (s) =>
                  MapEntry(s['stat']['name'] as String, s['base_stat'] as int),
            ) ??
            [],
      ),
    );
  }
}
