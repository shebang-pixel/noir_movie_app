class Movie {
  final int id;
  final String title;
  final String overview;
  final double rating;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final List<int> genreIds;
  final bool adult;
  final bool video;
  final double popularity;
  final int voteCount;
  final String contentType;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.rating,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.genreIds,
    required this.adult,
    required this.video,
    required this.popularity,
    required this.voteCount,
    required this.contentType,
  });

  /// Convert JSON → Movie object with auto-detection for Movie vs TV
  factory Movie.fromJson(Map<String, dynamic> json) {
    // Detect type: Use 'media_type' if present, otherwise check for 'title' vs 'name'
    final String detectedType = json['media_type'] ?? 
                               (json.containsKey('title') ? 'movie' : 'tv');

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'No title',
      overview: json['overview'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
      popularity: (json['popularity'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      contentType: detectedType,
    );
  }
}
