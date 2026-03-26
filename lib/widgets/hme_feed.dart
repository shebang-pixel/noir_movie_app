
import 'dart:async';

import 'package:flutter/material.dart';

class HmeFeed extends StatefulWidget{
  final dynamic movies;

  const HmeFeed({super.key,required this.movies});

  @override
    State<HmeFeed> createState() => _HmeFeedState();
  }

class _HmeFeedState extends State<HmeFeed> {
  // controller
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  late Timer _timer;

  @override
  initState(){
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if(widget.movies.isEmpty) { return; }

      //Move to next page
      _currentPage++;

      // if reach the end → go back to start
      if (_currentPage >= widget.movies.length) {
        _currentPage = 0;
      }

      //Tell PageView to move
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500), // animation speed
        curve: Curves.easeInOut, // smooth animation
      );
    });
  }

  @override
  void dispose() {
    // 🧹 Clean up (VERY IMPORTANT)
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 475,

      child: PageView.builder(
        controller: _controller, // connect remote to TV

        itemCount: widget.movies.length,

        // 👇 This updates when user swipes manually
        onPageChanged: (index) {
          _currentPage = index;
        },

        itemBuilder: (context, index) {
          final movie = widget.movies[index];

          return _MovieCard(
            title: movie['title'],
            year: movie['year'],
            rating: movie['rating'],
            description: movie['description'],
            genre: movie['genre'],
            posterUrl: movie['poster'],
          );
        },
      ),
    );
  }
}


// Reusable class
class _MovieCard extends StatelessWidget {
  const _MovieCard({
    required this.description,
    required this.genre,
    required this.posterUrl,
    required this.title,
    required this.year,
    required this.rating,
  });

  final String title;
  final int year;
  final double rating;
  final String description;
  final String genre;
  final String posterUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shadowColor: Colors.black.withAlpha(100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 2 / 2.5,
                child: Image.network(
                  posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.broken_image, size: 50),
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
                        rating.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 10,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$year • $genre',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
}