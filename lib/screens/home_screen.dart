import 'package:flutter/material.dart';
import '../widgets/hme_feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Home'),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Latest'),
                  Tab(text: 'Popular'),
                  Tab(text: 'Top Rated'),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: HmeFeed(movies:
                <Map<String, dynamic>> [
                  {
                    "title": 'The Shawshank Redemption',
                    "year": 1994,
                    "rating": 9.3,
                    "description":
                    'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
                    "genre": 'Drama',
                    "poster": 'https://picsum.photos/250/300',
                  },
                  {
                    "title": 'The Godfather',
                    "year": 1972,
                    "rating": 9.2,
                    "description":
                    'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
                    "genre": 'Crime, Drama',
                    "poster": 'https://picsum.photos/250/300',
                  },
                  {
                    "title": 'The Dark Knight',
                    "year": 2008,
                    "rating": 9.0,
                    "description":
                    'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one',
                    "genre": 'Action, Crime, Drama',
                    "poster": 'https://picsum.photos/250/300',
                  },
                ],),
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
