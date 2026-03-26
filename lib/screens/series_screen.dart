import 'package:flutter/material.dart';

class SeriesScreen extends StatefulWidget{
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
            Tab(text:'Latest'),
            Tab(text:'Popular'),
            Tab(text:'Top Rated'),
          ]
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Latest')),
            Center(child: Text('Popular')),
            Center(child: Text('Top Rated')),
          ]
        ),
      )
    );
  }

}