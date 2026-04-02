import 'package:flutter/material.dart';
import '../widgets/home_feed.dart';
import 'content_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: const Text('Noir'),
                  centerTitle: true,
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingsScreen(
                              isDarkMode: widget.isDarkMode,
                              onThemeChanged: widget.onThemeChanged,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Latest'),
                      Tab(text: 'Popular'),
                      Tab(text: 'Top Rated'),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: HomeFeed()),
            ];
          },
          body: const TabBarView(
            children: [
              _TabContentWrapper(
                child: ContentScreen(
                  params: {
                    'sort_by': 'release_date.desc',
                    'page': '1',
                    'include_adult': 'false',
                    'with_original_language': 'en',
                    'with_genres': '28,12,16',
                    'popularity.gte': '100',
                    'vote_count.gte': '500',
                  },
                  type: 'movie',
                ),
              ),
              _TabContentWrapper(
                child: ContentScreen(
                  params: {
                    'sort_by': 'popularity.desc',
                    'page': '1',
                    'include_adult': 'false',
                    'with_original_language': 'en',
                  },
                  type: 'movie',
                ),
              ),
              _TabContentWrapper(
                child: ContentScreen(
                  params: {
                    'vote_average.gte': '7',
                    'vote_count.gte': '100',
                    'sort_by': 'release_date.desc',
                    'page': '1',
                    'include_adult': 'false',
                  },
                  type: 'movie',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabContentWrapper extends StatelessWidget {
  final Widget child;
  const _TabContentWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverFillRemaining(child: child),
          ],
        );
      },
    );
  }
}
