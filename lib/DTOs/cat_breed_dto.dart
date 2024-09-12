class CatBreedDTO {
  final String id;
  final String name;
  final String description;
  final String origin;
  final int intelligence;
  final int adaptability;
  final String lifeSpan;
  final int affectionLevel;
  final int childFriendly;
  final int strangerFriendly;
  final int dogFriendly;
  final int energyLevel;
  final int socialNeeds;
  final String imageUrl;

  CatBreedDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.origin,
    required this.intelligence,
    required this.adaptability,
    required this.lifeSpan,
    required this.affectionLevel,
    required this.childFriendly,
    required this.strangerFriendly,
    required this.dogFriendly,
    required this.energyLevel,
    required this.socialNeeds,
    required this.imageUrl,
  });
}
