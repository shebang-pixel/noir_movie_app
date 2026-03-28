import 'dart:async';
import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';import 'movie_card.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer; // Changed to nullable to avoid late initialization errors
  late Future<List<Movie>> _moviesFuture;
  List<Movie> _loadedMovies = []; // Local list to track length for the timer

  @override
  void initState() {
    super.initState();
    _moviesFuture = MovieService().fetchMovie('movie',{
      'vote_average.gte': '7',
      'vote_count.gte': '100',
      'sort_by': 'popularity.desc',
      'page': '1',
    });

    // Start timer once data is loaded
    _moviesFuture.then((movies) {
      if (!mounted) return;
      setState(() {
        _loadedMovies = movies;
      });
      _startAutoPlay();
    });
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_loadedMovies.isEmpty || !mounted) return;

      _currentPage++;
      if (_currentPage >= _loadedMovies.length) {
        _currentPage = 0;
      }

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 450,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final movies = snapshot.data!;

        return SizedBox(
          height: 450, // PageView needs a height
          child: PageView.builder(
            controller: _controller,
            itemCount: movies.length,
            onPageChanged: (index) {
              _currentPage = index;
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: MovieCard(movie: movies[index]), // Pass single movie
              );
            },
          ),
        );
      },
    );
  }
}