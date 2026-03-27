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
  });

  /// Convert JSON → Movie object
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No title',
      overview: json['overview'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
      popularity: (json['popularity'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
    );
  }
}