import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  static const String url = "http://www.omdbapi.com/?t=inception&apikey=622cae01";

  Future<_Result<MovieModel>> fetchMovie() async {
    final response = await http.get(Uri.parse(url));

    if(response.statusCode != 200) {
      return _Result.failure("Error: ${response.statusCode}");
    }

    final movie = MovieModel.fromJson(json.decode(response.body));
    return _Result.success(movie);
  }
}

class _Result<T> {
  final T? data;
  final String? error;

  _Result.success(this.data) : error = null;
  _Result.failure(this.error) : data = null;
}