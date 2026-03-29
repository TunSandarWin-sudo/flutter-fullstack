class Movie {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final double rating;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}