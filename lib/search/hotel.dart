class Hotel {
  final int id;
  final String name;
  final String city;
  final String image;
  final double rating;
  final bool recommended;
  final double price;
  final DateTime timestamp;

  Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.image,
    required this.rating,
    required this.recommended,
    required this.price,
    required this.timestamp,
  });
}