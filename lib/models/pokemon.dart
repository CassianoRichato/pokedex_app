class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;
  final List<int> evolutions;
  bool? isCaptured;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.types = const [],
    this.abilities = const [],
    this.stats = const {},
    this.evolutions = const [],
    this.isCaptured,
  });

  String get displayName =>
      name.isNotEmpty ? '${name[0].toUpperCase()}${name.substring(1)}' : name;

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
      evolutions: [],
      isCaptured: false,
    );
  }
}
