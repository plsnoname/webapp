class Room {
  final String type;
  final String name;
  final List<String> mediaFiles;
  final String description;
  final int number;
  final List<String> facilities;
  final List<Extra> extras;
  final double defaultPrice;
  final int maxAnimals;

  Room({
    required this.type,
    required this.name,
    required this.mediaFiles,
    required this.description,
    required this.number,
    required this.facilities,
    required this.extras,
    required this.defaultPrice,
    required this.maxAnimals,
  });
}

class Extra {
  final double price;
  final String description;

  Extra({
    required this.price,
    required this.description,
  });
}
