import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static final String _apiKey = dotenv.env['API_KEY']!;

  /// Fetches movies from the API by ID
  Future<Movie> fetchById(String type, String id) async {
    // Build the URL for TMDB's /movie/{id} or /tv/{id} endpoint
    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/$type/$id', // type = 'movie' or 'tv'
      {
        'api_key': _apiKey,
        'language': 'en-US', // optional
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      // Throw error for proper handling
      throw Exception('Failed to fetch $type with ID $id');
    }

    // Convert the response JSON into a Movie object
    return Movie.fromJson(json.decode(response.body));
  }

  /// Uses '/search' if 'query' is present in params, otherwise uses '/discover'.
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

    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final movieResponse = MovieWrapper.fromJson(data);
      return movieResponse.movies;
    } else {
      throw Exception('${response.statusCode}: Failed to load movies');
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
