import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String baseUrl =
    "https://flutter-fullstack.vercel.app/api/movies";

  static Future<List<Movie>> fetchMovies() async {
  final response = await http.get(Uri.parse(baseUrl));

  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data.map<Movie>((json) => Movie.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load movies");
  }
}

  static Future<void> updateMovie(int id, double rating) async {
  final response = await http.put(
    Uri.parse("$baseUrl/$id"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "rating": rating,
      "description": "Updated from Flutter"
    }),
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to update movie");
  }
}
}