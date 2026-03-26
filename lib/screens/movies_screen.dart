import 'package:flutter/material.dart';

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
                  Center(child: Text('Latest')),
                  Center(child: Text('Popular')),
                  Center(child: Text('Top Rated')),
                ]
              )
            )
          ],
        ),
    ));
  }
}
