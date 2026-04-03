import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../screens/movie_info_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    // TMDB poster base URL
    const String imageUrl = 'https://image.tmdb.org/t/p/w500';

    void onCardTap() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MovieInfoScreen(movie: movie)),
      );
    }

    return GestureDetector(
      onTap: onCardTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image.network(
            //   movie.posterPath.isNotEmpty
            //       ? '$imageUrl${movie.posterPath}'
            //       : 'https://via.placeholder.com/500x750?text=No+Image',
            //   fit: BoxFit.cover,
            //   errorBuilder: (context, error, stackTrace) => const Center(
            //     child: Icon(Icons.broken_image, color: Colors.white, size: 40),
            //   ),
            // )
            CachedNetworkImage(
              imageUrl: movie.posterPath.isNotEmpty
                  ? '$imageUrl${movie.posterPath}'
                  : 'https://via.placeholder.com/500x750?text=No+Image',
              placeholder: (context, url) => Container(color: Colors.grey[900]),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
            // Gradient Overlay for text readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      movie.rating.toStringAsFixed(
                        1,
                      ), // Fixed: use instance 'movie'
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    movie.releaseDate.isNotEmpty
                        ? movie.releaseDate.split('-')[0]
                        : 'N/A', // Just the year
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
