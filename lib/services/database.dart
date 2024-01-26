import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:netflix/models/movie.dart';
import 'package:netflix/models/user.dart';
import 'package:netflix/services/auth.dart';
import 'package:netflix/services/load_data.dart';

class DatabaseService {
  final db = FirebaseFirestore.instance;

  //Users management

  Future<AppUser?> getCurrentUser() async {
    try {
      final user = await AuthService()
          .getCurrentUser(); // Use your existing method to get the user

      if (user != null) {
        final userSnapshot = await db
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData =
              userSnapshot.docs.first.data() as Map<String, dynamic>;
          return AppUser(
            username: userData['username'],
            email: userData['email'],
            name: userData['name'],
            surname: userData['surname'],
          );
        }
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  getUser(String email) async {
    final user = await db
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        return null;
      }
    });
    if (user != null) {
      return AppUser(
        username: user['username'],
        email: user['email'],
        name: user['name'],
        surname: user['surname'],
      );
    } else {
      return null;
    }
  }

  Future<void> addUser(String email, String username, String name,
      String surname, String password) async {
    final user = await getUser(email);
    if (user == null) {
      await db.collection('users').add({
        'email': email,
        'username': username,
        'name': name,
        'surname': surname,
        'password': password
      });
      AuthService().registerWithEmailPassword(email, password);
    }
  }

  //Movies management

  Future<bool> checkIfDataLoaded(String collectionName) async {
    final movies = await db.collection(collectionName).get();
    return movies.docs.isNotEmpty;
  }

  Future<void> loadMoviesIntoFirestore() async {
    bool isDataLoaded = await checkIfDataLoaded('movies');
    if (isDataLoaded) {
      return;
    }
    List<Movie> movies = await LoadData.loadMovies();
    for (var movie in movies) {
      await db.collection('movies').add(movie.toJson());
    }
  }

  Future<List<Movie>> getMovies() async {
    final movies = await db.collection('movies').get();
    return movies.docs.map((doc) => Movie.fromJson(doc.data())).toList();
  }

  //Series management

  Future<void> loadSeriesIntoFirestore() async {
    bool isDataLoaded = await checkIfDataLoaded('shows');
    if (isDataLoaded) {
      return;
    }
    List<Movie> series = await LoadData.loadSeries();
    for (var serie in series) {
      await db.collection('shows').add(serie.toJson());
    }
  }

  Future<List<Movie>> getSeries() async {
    final series = await db.collection('shows').get();
    return series.docs.map((doc) => Movie.fromJson(doc.data())).toList();
  }

  //Favorites management

  Future<bool> isFavorite(String title) async {
    User? user = await AuthService().user.first;
    final favorites = await db
        .collection('favorites')
        .where('email', isEqualTo: user?.email)
        .where('title', isEqualTo: title)
        .get();
    return favorites.docs.isNotEmpty;
  }

  Future<void> addFavorite(String title) async {
    User? user = await AuthService().user.first;
    if (user != null) {
      await db
          .collection('favorites')
          .add({'email': user.email, 'title': title});
    }
  }

  Future<void> removeFavorite(String title) async {
    User? user = await AuthService().user.first;
    if (user != null) {
      final favorites = await db
          .collection('favorites')
          .where('email', isEqualTo: user.email)
          .where('title', isEqualTo: title)
          .get();
      if (favorites.docs.isNotEmpty) {
        await db.collection('favorites').doc(favorites.docs.first.id).delete();
      }
    }
  }

  Future<List<Movie>> getFavorites() async {
    User? user = await AuthService().user.first;
    final favorites = await db
        .collection('favorites')
        .where('email', isEqualTo: user?.email)
        .get();
    List<Movie> movies = [];
    for (var favorite in favorites.docs) {
      final movie = await db
          .collection('movies')
          .where('title', isEqualTo: favorite['title'])
          .get();
      if (movie.docs.isNotEmpty) {
        movies.add(Movie.fromJson(movie.docs.first.data()));
      }
      final series = await db
          .collection('shows')
          .where('title', isEqualTo: favorite['title'])
          .get();
      if (series.docs.isNotEmpty) {
        movies.add(Movie.fromJson(series.docs.first.data()));
      }
    }
    return movies;
  }

  //Watchlist management

  Future<bool> isWatched(String title) async {
    User? user = await AuthService().user.first;
    final seen = await db
        .collection('seen')
        .where('email', isEqualTo: user?.email)
        .where('title', isEqualTo: title)
        .get();
    return seen.docs.isNotEmpty;
  }

  Future<void> addWatchlist(String title) async {
    User? user = await AuthService().user.first;
    if (user != null) {
      await db.collection('seen').add({'email': user.email, 'title': title});
    }
  }

  Future<void> removeWatchlist(String title) async {
    User? user = await AuthService().user.first;
    if (user != null) {
      final seen = await db
          .collection('seen')
          .where('email', isEqualTo: user.email)
          .where('title', isEqualTo: title)
          .get();
      if (seen.docs.isNotEmpty) {
        await db.collection('seen').doc(seen.docs.first.id).delete();
      }
    }
  }

  Future<List<Movie>> getWatchlist() async {
    User? user = await AuthService().user.first;
    final seenList = await db
        .collection('seen')
        .where('email', isEqualTo: user?.email)
        .get();
    List<Movie> movies = [];
    for (var seen in seenList.docs) {
      final movie = await db
          .collection('movies')
          .where('title', isEqualTo: seen['title'])
          .get();
      if (movie.docs.isNotEmpty) {
        movies.add(Movie.fromJson(movie.docs.first.data()));
      }
      final series = await db
          .collection('shows')
          .where('title', isEqualTo: seen['title'])
          .get();
      if (series.docs.isNotEmpty) {
        movies.add(Movie.fromJson(series.docs.first.data()));
      }
    }
    return movies;
  }
}
