import 'package:flutter/material.dart';
import 'content_screen.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Movies'),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Latest'),
                  Tab(text: 'Popular'),
                  Tab(text: 'Top Rated'),
                ]
              )
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  // 1. Latest movie Screen
                  ContentScreen(params: {
                    'sort_by': 'release_date.desc',
                    'page': '1',
                    'include_adult': 'false',
                    'with_original_language': 'en',
                    'with_genres': '28,12,16',
                    'popularity.gte': '100',
                    'vote_count.gte': '500'
                  }, type: 'movie'),

                  // 2. Popular movie Screen
                  ContentScreen(params: {
                    'sort_by': 'popularity.desc',
                    'page': '1',
                    'include_adult': 'false',
                    'with_original_language': 'en',
                  }, type: 'movie'),
                  // 3. Top Rated movie Screen
                  ContentScreen(params: {
                    'vote_average.gte': '8',
                    'vote_count.gte': '100',
                    'sort_by': 'release_date.desc',
                    'page': '1',
                    'include_adult': 'false',
                  }, type: 'movie'),
                ]
              )
            )
          ],
        ),
    ));
  }
}
