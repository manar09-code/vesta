/// Modèle d'annonce — partagé par tous les modules (Search, Détails,
/// Favoris, Publication…). Version Dart du modèle décrit au C4 niveau 4.
class Listing {
  const Listing({
    required this.id,
    required this.title,
    required this.location,
    required this.type,
    required this.transaction,
    required this.price,
    required this.area,
    required this.rooms,
    required this.baths,
    required this.image,
    required this.description,
  });

  final String id;
  final String title;

  /// Ex. « La Marsa, Tunis ».
  final String location;

  /// Ex. « Villa », « Appartement ».
  final String type;

  /// `vente` ou `location`.
  final String transaction;

  /// Prix en TND (par mois si location).
  final int price;
  final int area;
  final int rooms;
  final int baths;

  /// Illustration principale (`assets/images/<image>.png`).
  final String image;
  final String description;

  bool get isSale => transaction == 'vente';

  String get transactionLabel => isSale ? 'À vendre' : 'À louer';

  /// Galerie : illustration principale + deux visuels d'intérieur,
  /// comme dans la maquette.
  List<String> get gallery => [image, 'living-room', 'kitchen'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'location': location,
        'type': type,
        'transaction': transaction,
        'price': price,
        'area': area,
        'rooms': rooms,
        'baths': baths,
        'image': image,
        'description': description,
      };

  factory Listing.fromMap(Map<String, dynamic> map) => Listing(
        id: map['id'] as String,
        title: map['title'] as String,
        location: map['location'] as String,
        type: map['type'] as String,
        transaction: map['transaction'] as String,
        price: (map['price'] as num).toInt(),
        area: (map['area'] as num).toInt(),
        rooms: (map['rooms'] as num).toInt(),
        baths: (map['baths'] as num).toInt(),
        image: map['image'] as String,
        description: map['description'] as String,
      );
}

/// Jeu de données de démonstration — identique à la maquette web.
const demoListings = <Listing>[
  Listing(
    id: 'marsa',
    title: 'Villa des Oliviers',
    location: 'La Marsa, Tunis',
    type: 'Villa',
    transaction: 'vente',
    price: 1250000,
    area: 240,
    rooms: 4,
    baths: 3,
    image: 'villa',
    description:
        'Une villa lumineuse avec terrasse et jardin, à deux pas de la mer. De beaux espaces pour imaginer votre prochain quotidien.',
  ),
  Listing(
    id: 'lac',
    title: 'L’Appartement Lumière',
    location: 'Les Berges du Lac, Tunis',
    type: 'Appartement',
    transaction: 'vente',
    price: 420000,
    area: 108,
    rooms: 3,
    baths: 2,
    image: 'apartment',
    description:
        'Un appartement chaleureux avec un séjour ouvert et de grandes baies vitrées. Un cadre paisible, proche des commerces et des services.',
  ),
  Listing(
    id: 'sousse',
    title: 'Le Patio Bleu',
    location: 'Sousse, Sousse',
    type: 'Appartement',
    transaction: 'location',
    price: 1800,
    area: 82,
    rooms: 2,
    baths: 1,
    image: 'coast',
    description:
        'Un cocon clair et accueillant avec un patio ensoleillé, idéal pour profiter de la ville et de la côte.',
  ),
  Listing(
    id: 'menzah',
    title: 'Maison des Jasmins',
    location: 'El Menzah, Tunis',
    type: 'Villa',
    transaction: 'location',
    price: 3200,
    area: 165,
    rooms: 3,
    baths: 2,
    image: 'villa',
    description:
        'Une maison familiale avec jardin et espace de vie généreux, dans un quartier calme et bien desservi.',
  ),
];
