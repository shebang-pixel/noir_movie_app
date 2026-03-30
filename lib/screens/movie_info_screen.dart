import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/movie_card.dart';

class MovieInfoScreen extends StatefulWidget {
  final Movie movie;
  const MovieInfoScreen({super.key, required this.movie});

  @override
  State<MovieInfoScreen> createState() => _MovieInfoScreenState();
}

class _MovieInfoScreenState extends State<MovieInfoScreen> {
  bool isInWatchList = false; // Tracks if movie/series is already in watchlist

  @override
  void initState() {
    super.initState();
    _checkWatchList(); // Check at startup if this movie is already saved
  }

  /// Check SharedPreferences if the movie/series is already in watchlist
  Future<void> _checkWatchList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = widget.movie.contentType == 'movie'
        ? prefs.getStringList('watchList') ?? []
        : prefs.getStringList('tvWatchList') ?? [];

    setState(() {
      isInWatchList = list.contains(widget.movie.id.toString());
    });
  }

  /// Add movie/series to SharedPreferences watchlist
  Future<void> addToWatchList() async {
    final prefs = await SharedPreferences.getInstance();
    final key = widget.movie.contentType == 'movie' ? 'watchList' : 'tvWatchList';

    List<String> list = prefs.getStringList(key) ?? [];

    if (!list.contains(widget.movie.id.toString())) {
      list.add(widget.movie.id.toString());
      await prefs.setStringList(key, list);

      // Update button text
      setState(() {
        isInWatchList = true;
      });

      // Show confirmation
      _showSnackBar('Added to watchlist');
    } else {
      _showSnackBar('Already in watchlist');
    }
  }

  /// Helper to show a SnackBar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String imageUrl = 'https://image.tmdb.org/t/p/w500';
    const String backdropUrl = 'https://image.tmdb.org/t/p/original';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// Collapsing Image Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            title: Text(widget.movie.title),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.movie.backdropPath.isNotEmpty
                        ? '$backdropUrl${widget.movie.backdropPath}'
                        : '$imageUrl${widget.movie.posterPath}',
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Movie Details
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    /// Rating, Date, and Add to Watchlist Button
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          widget.movie.rating.toStringAsFixed(1),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.calendar_month, color: Colors.grey, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          widget.movie.releaseDate,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const Spacer(),

                        /// Watchlist button
                        ElevatedButton(
                          onPressed: isInWatchList ? null : addToWatchList,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isInWatchList ? Colors.grey : Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            isInWatchList ? 'In Watchlist' : 'Add to Watchlist',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Overview',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.movie.overview,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 24),

                    _buildInfoTile(Icons.trending_up, 'Popularity',
                        widget.movie.popularity.toString()),
                    _buildInfoTile(
                        Icons.how_to_vote, 'Vote Count', widget.movie.voteCount.toString()),
                    _buildInfoTile(Icons.fingerprint, 'Movie ID', widget.movie.id.toString()),

                    if (widget.movie.adult)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '18+',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  /// Reusable tile for stats
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}