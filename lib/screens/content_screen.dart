import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../models/movie_model.dart';
import '../widgets/movie_card.dart';
import '../widgets/error_view.dart'; // Import the new widget

class ContentScreen extends StatefulWidget {
  final Map<String, String>? params;
  final String? type;
  final List<Movie>? movies;

  const ContentScreen({
    super.key,
    required this.params,
    required this.type,
  }) : movies = null;

  const ContentScreen.fromList({
    super.key,
    required this.movies,
  })  : params = null,
        type = null;

  @override
  State<StatefulWidget> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Method to (re)load data
  void _loadData() {
    setState(() {
      if (widget.movies != null) {
        _moviesFuture = Future.value(widget.movies);
      } else {
        _moviesFuture = MovieService().fetchMovie(widget.type!, widget.params!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // STRATEGIC USE: Show the custom error view with a retry action
            return ErrorView(
              message: snapshot.error.toString(),
              onRetry: _loadData,
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found.'));
          }

          final movies = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index]);
            },
          );
        },
      ),
    );
  }
}
