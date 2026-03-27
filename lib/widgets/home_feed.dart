import 'movie_card.dart';
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
        duration: const Duration(milliseconds:800), // animation speed
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

          return MovieCard(
            movie: movie,
          );
        },
      ),
    );
  }
}

