import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late double rating;
  bool isLoading = false; // ✅ loading state

  @override
  void initState() {
    super.initState();
    rating = widget.movie.rating;
  }

  Future<void> updateRating() async {
    setState(() {
      isLoading = true;
    });

    try {
      await ApiService.updateMovie(widget.movie.id, rating);

      // create updated movie object
      final updatedMovie = Movie(
        id: widget.movie.id,
        title: widget.movie.title,
        description: widget.movie.description,
        imageUrl: widget.movie.imageUrl,
        rating: rating,
      );

      // show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Updated successfully ✅")),
      );

      // small delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      // return updated movie to HomeScreen
      Navigator.pop(context, updatedMovie);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update failed ❌")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎬 Movie Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(widget.movie.imageUrl),
            ),

            const SizedBox(height: 15),

            // 📝 Description
            Text(
              widget.movie.description,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // ⭐ Rating Display
            Text(
              "⭐ Rating: ${rating.toStringAsFixed(1)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 🎚 Slider
            Slider(
              value: rating,
              min: 0,
              max: 5,
              divisions: 5,
              label: rating.toString(),
              onChanged: isLoading
                  ? null
                  : (value) {
                      setState(() {
                        rating = value;
                      });
                    },
            ),

            const SizedBox(height: 20),

            // 🔘 Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : updateRating,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Update Rating"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}