class ExhibitorModel {
  final String id;
  final String name;
  final String category;
  final String hall;
  final String booth;
  final String? description;
  final String? logoUrl;
  final List<String>? brochures;
  final bool isFavorite;

  ExhibitorModel({
    required this.id,
    required this.name,
    required this.category,
    required this.hall,
    required this.booth,
    this.description,
    this.logoUrl,
    this.brochures,
    this.isFavorite = false,
  });

  String get initials {
    if (name.isEmpty) return "";
    List<String> names = name.split(" ");
    if (names.length > 1) {
      return "${names[0][0]}${names[1][0]}".toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
