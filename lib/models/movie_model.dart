// {
// "Title": "Inception",
// "Year": "2010",
// "Rated": "PG-13",
// "Released": "16 Jul 2010",
// "Runtime": "148 min",
// "Genre": "Action, Adventure, Sci-Fi",
// "Director": "Christopher Nolan",
// "Writer": "Christopher Nolan",
// "Actors": "Leonardo DiCaprio, Joseph Gordon-Levitt, Elliot Page",
// "Plot": "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO, but his tragic past may doom the project and his team to disaster.",
// "Language": "English, Japanese, French",
// "Country": "United States, United Kingdom",
// "Awards": "Won 4 Oscars. 160 wins & 220 nominations total",
// "Poster": "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_SX300.jpg",
// "imdbRating": "8.8",
// }

class MovieModel {
  const MovieModel({
    required this.title,
    required this.released,
    required this.genre,
    required this.country,
    required this.rating,
    required this.plot,
    required this.run_time,
    required this.poster_url,
});
  final String title;
  final String released;
  final String run_time;
  final String genre;
  final String country;
  final String poster_url;
  final String rating;
  final String plot;

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
        title: json['Title'],
        released: json['Released'],
        genre: json['Genre'],
        country: json['Country'],
        rating: json['imdbRating'],
        plot: json['Plot'],
        run_time: json['Runtime'],
        poster_url: json['Poster']
    );
  }
}