import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieInfoScreen extends StatelessWidget {
  final Movie movie;
  const MovieInfoScreen({super.key, required this.movie});

  // TODO: add a button that adds item to watchlist

  @override
  Widget build(BuildContext context) {
    const String imageUrl = 'https://image.tmdb.org/t/p/w500';
    const String backdropUrl = 'https://image.tmdb.org/t/p/original';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Collapsing Image Header
          SliverAppBar(
            expandedHeight: 300,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.black54,
            pinned: true,
            title: Text(movie.title),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    movie.backdropPath.isNotEmpty
                        ? '$backdropUrl${movie.backdropPath}'
                        : '$imageUrl${movie.posterPath}',
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

          // 2. Movie Details
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title in content area
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Rating and Date Row
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          movie.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.calendar_month, color: Colors.grey, size: 20),
                        const SizedBox(width: 4),
                        Text(movie.releaseDate, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Overview
                    Text('Overview', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 24),

                    // Stats Grid or List
                    _buildInfoTile(Icons.trending_up, 'Popularity', movie.popularity.toString()),
                    _buildInfoTile(Icons.how_to_vote, 'Vote Count', movie.voteCount.toString()),
                    _buildInfoTile(Icons.fingerprint, 'Movie ID', movie.id.toString()),
                    
                    if (movie.adult)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                        child: const Text('18+', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
