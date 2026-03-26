import 'package:flutter/material.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});
  @override
  State<StatefulWidget> createState() {
    return _WatchListState();
  }
}

class _WatchListState extends State<WatchList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('WatchList'),
              centerTitle: true,
              floating: true,
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Movies'),
                  Tab(text: 'Series'),
                  Tab(text: 'Trakt'),
                ],
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  Center(child: Text('Latest')),
                  Center(child: Text('Popular')),
                  Center(child: Text('Top Rated')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
