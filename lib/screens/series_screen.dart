import 'package:flutter/material.dart';
import 'content_screen.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Series'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Latest'),
              Tab(text: 'Popular'),
              Tab(text: 'Top Rated'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Latest series screen
            ContentScreen(
              params: {
                'sort_by': 'release_date.desc',
                'page': '1',
                'include_adult': 'false',
                'vote_average.gte': '7',
                'vote_count.gte': '100',
              },
              type: 'tv',
            ),

            // Series popular screen
            ContentScreen(
              params: {
                'sort_by': 'popularity.desc',
                'page': '1',
                'include_adult': 'false',
                'vote_average.gte': '7',
                'vote_count.gte': '100',
              },
              type: 'tv',
            ),

            // Series top rated screen
            ContentScreen(
              params: {
                'sort_by': 'vote_average.desc',
                'page': '1',
                'vote_average.gte': '8',
                'vote_count.gte': '100',
              },
              type: 'tv',
            ),
          ],
        ),
      ),
    );
  }
}
