import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'content_screen.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});
  @override
  State<StatefulWidget> createState() {
    return _WatchListState();
  }
}

class _WatchListState extends State<WatchList> {
  // get series list from local storage
  Future<List<Movie>> getItems(String contentType) async {

    // access resource
    final prefs = await SharedPreferences.getInstance();
    final key = contentType == 'movie' ? 'watchList' : 'tvWatchList';

    // return  list of stored movie/tv ids
    final idList = prefs.getStringList(key) ?? [];

    //   fetch by id
    // parallel fetching
    final List<Future<Movie>> fetchFutures = idList.map((id) =>
        MovieService().fetchById(contentType, id)
    ).toList();

    final List<Movie> movies = await Future.wait(fetchFutures);

    return movies;
  }

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
                  FutureBuilder<List<Movie>>(
                    future: getItems('movie'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No movies found.'));
                      }
                      return ContentScreen.fromList(movies: snapshot.data!);
                    },
                  ),
                  FutureBuilder<List<Movie>>(
                    future: getItems('tv'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No movies found.'));
                      }
                      return ContentScreen.fromList(movies: snapshot.data!);
                    },
                  ),
                  Center(child: Text('Trakt')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
