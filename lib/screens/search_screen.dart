import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';
import 'content_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final MovieService _movieService = MovieService();

  // Handle the search logic
  void _handleSearch(String query) async {
    if (query.trim().isEmpty) return;

    // 1. Show a loading indicator so the user knows something is happening
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 2. Await the actual list of movies
      final List<Movie> movies = await _movieService.fetchMovie('movie', {
        'query': query.trim(),
      });

      // 3. Remove the loading indicator
      if (!mounted) return;
      Navigator.pop(context);

      // 4. Navigate and pass the REAL List<Movie>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              _SearchPage(widget: ContentScreen.fromList(movies: movies)),
        ),
      );
    } catch (e) {
      // Handle errors (like no internet)
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search for movies...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _handleSearch, // Call the async handler
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchPage extends StatelessWidget {
  final dynamic widget;

  const _SearchPage({required this.widget, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Results'), centerTitle: true),
      body: widget,
    );
  }
}
