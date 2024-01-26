class Movie {
  final int show_id;
  final String type;
  final String title;
  final String director;
  final String country;
  final String date_added;
  final int release_year;
  final String rating;
  final String duration;
  final String listed_in;
  final String description;

  Movie({
    required this.show_id,
    required this.type,
    required this.title,
    required this.director,
    required this.country,
    required this.date_added,
    required this.release_year,
    required this.rating,
    required this.duration,
    required this.listed_in,
    required this.description,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      show_id: json['show_id'],
      type: json['type'],
      title: json['title'],
      director: json['director'],
      country: json['country'],
      date_added: json['date_added'],
      release_year: json['release_year'],
      rating: json['rating'],
      duration: json['duration'],
      listed_in: json['listed_in'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'show_id': show_id,
      'type': type,
      'title': title,
      'director': director,
      'country': country,
      'date_added': date_added,
      'release_year': release_year,
      'rating': rating,
      'duration': duration,
      'listed_in': listed_in,
      'description': description,
    };
  }
}
