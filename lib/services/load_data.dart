import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:netflix/models/movie.dart';

class LoadData {
  static Future<List<Movie>> loadMovies() async {
    final String response = await rootBundle.loadString('assets/movies.json');
    final data = await json.decode(response);
    final List<Movie> movies = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i]['type'] == 'Movie') {
        movies.add(Movie.fromJson(data[i]));
      }
    }
    return movies;
  }

  static Future<List<Movie>> loadSeries() async {
    final String response = await rootBundle.loadString('assets/movies.json');
    final data = await json.decode(response);
    final List<Movie> movies = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i]['type'] == 'TV Show') {
        movies.add(Movie.fromJson(data[i]));
      }
    }
    return movies;
  }
}
