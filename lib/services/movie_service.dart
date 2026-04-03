import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static final String _apiKey = dotenv.env['API_KEY']!;

  /// Fetches content by ID with a 30-second timeout
  Future<Movie> fetchById(String type, String id) async {
    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/$type/$id',
      {'api_key': _apiKey, 'language': 'en-US'},
    );

    try {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Connection timed out'),
      );

      if (response.statusCode == 200) {
        return Movie.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load $type');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches a list of content with a 30-second timeout
  Future<List<Movie>> fetchMovie(String type, Map<String, String> params) async {
    final bool isSearch = params.containsKey('query') && params['query']!.isNotEmpty;
    final String endpoint = isSearch ? 'search' : 'discover';

    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/$endpoint/$type',
      {
        'api_key': _apiKey,
        'include_adult': 'false',
        ...params,
      },
    );

    try {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Connection timed out'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MovieWrapper.fromJson(data).movies;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      rethrow;
    }
  }
}

class MovieWrapper {
  final List<Movie> movies;
  final int page;

  MovieWrapper({required this.movies, required this.page});

  factory MovieWrapper.fromJson(Map<String, dynamic> json) {
    return MovieWrapper(
      page: json['page'] ?? 1,
      movies: (json['results'] as List? ?? [])
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList(),
    );
  }
}
