import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../models/movie_model.dart';
import '../widgets/movie_card.dart';

class ContentScreen extends StatefulWidget {
  // Data fields
  final Map<String, String>? params;
  final String? type;
  final List<Movie>? movies;

  // 1.Gets raw data from the API
  const ContentScreen({
    super.key,
    required this.params,
    required this.type,
  }) : movies = null;

  //  2.Gets data from existing
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
    if(widget.movies != null){
      // data is ready
      _moviesFuture = Future.value(widget.movies);
    } else {
      // fetch from api
      _moviesFuture = MovieService().fetchMovie(widget.type!, widget.params!);
    }
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
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found.'));
          }

          final movies = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7, // Adjust for poster height
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(movie: movie);
            },
          );
        },
      ),
    );
  }
}
