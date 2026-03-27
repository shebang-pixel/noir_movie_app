import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static final String _apiKey = dotenv.env['API_KEY']!;

  //   get movies

  Future<List<Movie>> fetchMovie(Map<String, String> params) async {
    final uri = Uri.https('api.themoviedb.org', '/3/discover/movie', {
      "api_key": _apiKey,
      "include_adult": "false",
      ...params,
    });

    final response = await http.get(uri);
    final data = json.decode(response.body);
    final movieResponse = MovieWrapper.fromJson(data);
    final movies = movieResponse.movies;


    if (response.statusCode == 200) {
      return movies;
    } else {
      throw Exception('${response.statusCode}:Failed to load movies');
    }
  }
}

//Wrapper class
class MovieWrapper{
  final List<Movie> movies;
  final int page;

  MovieWrapper({required this.movies,required this.page});

  factory MovieWrapper.fromJson(Map<String, dynamic> json){
    return MovieWrapper(
      page: json['page'],
      // Convert list of JSON → list of Movie objects
      movies: (json['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList(),
    );
  }


}