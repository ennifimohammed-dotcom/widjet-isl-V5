class Dhikr {
  final String text;
  final String transliteration;
  final String translation;
  final int count;
  final String source;
  final bool isTasbih;

  Dhikr({
    required this.text,
    required this.transliteration,
    required this.translation,
    required this.count,
    required this.source,
    this.isTasbih = false,
  });
}

class DhikrCategory {
  final String name;
  final String iconName;  // Stocké comme string pour éviter les imports Material
  final String description;
  final List<Dhikr> adhkar;

  DhikrCategory({
    required this.name,
    required this.iconName,
    required this.description,
    required this.adhkar,
  });
}
