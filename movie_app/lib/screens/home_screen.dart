import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> movies;
  List<Movie> movieList = []; // ✅ store data locally

  @override
  void initState() {
    super.initState();
    movies = ApiService.fetchMovies();
  }

  // optional refresh (manual)
  void refreshMovies() {
    setState(() {
      movies = ApiService.fetchMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movies")),

      body: FutureBuilder<List<Movie>>(
        future: movies,
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // error
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }

          // ✅ save data once
          if (movieList.isEmpty) {
            movieList = snapshot.data!;
          }

          return ListView.builder(
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              final movie = movieList[index];

              return Card(
                child: ListTile(
                  leading: movie.imageUrl.isNotEmpty
                      ? Image.network(movie.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.movie, size: 50),
                  title: Text(movie.title),
                  subtitle: Text("⭐ ${movie.rating}"),

                  // 🚀 UPDATED NAVIGATION (INSTANT UPDATE)
                  onTap: () async {
                    final updatedMovie = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(movie: movie),
                      ),
                    );

                    // ✅ update instantly without reload
                    if (updatedMovie != null && updatedMovie is Movie) {
                      setState(() {
                        final indexToUpdate = movieList.indexWhere(
                          (m) => m.id == updatedMovie.id,
                        );

                        if (indexToUpdate != -1) {
                          movieList[indexToUpdate] = updatedMovie;
                        }
                      });
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}