import 'package:flutter/material.dart';
import 'package:netflix/models/movie.dart';
import 'package:netflix/services/database.dart';
import 'package:netflix/widgets/navigation_bar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Movie> favoritesList = [];
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _databaseService.getFavorites().then((favorites) {
      setState(() {
        favoritesList = favorites;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      drawer: const NavigationDrawerWidget(),
      body: favoritesList.isEmpty
          ? const Center(
              child: Text('No movies or series in your favorites'),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: favoritesList.length,
                itemBuilder: (context, index) {
                  Movie movie = favoritesList[index];

                  return Stack(
                    children: [
                      Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                movie.director.isEmpty
                                    ? 'Director: Unknown'
                                    : 'Director: ${movie.director}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(movie.release_year.isNaN
                                  ? 'Release Year: Unknown'
                                  : 'Release Year: ${movie.release_year}'),
                              Text(movie.country.isEmpty
                                  ? 'Country: Unknown'
                                  : 'Country: ${movie.country}'),
                              Text(movie.rating.isEmpty
                                  ? 'Rating: Unknown'
                                  : 'Rating: ${movie.rating}'),
                              Text(movie.duration.isEmpty
                                  ? 'Duration: Unknown'
                                  : 'Duration: ${movie.duration}'),
                              Text(movie.type.isEmpty
                                  ? 'Type: Unknown'
                                  : 'Type: ${movie.type}')
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(movie.description),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FutureBuilder<bool>(
                                future:
                                    DatabaseService().isWatched(movie.title),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    if (snapshot.hasError) {
                                      return const Icon(
                                        Icons.visibility,
                                        color: Colors.grey,
                                      );
                                    } else {
                                      final isFavorite = snapshot.data!;
                                      return IconButton(
                                        onPressed: () {
                                          final isWatched = snapshot.data!;
                                          if (isWatched) {
                                            DatabaseService()
                                                .removeWatchlist(movie.title);
                                            setState(() {
                                              Colors.grey;
                                            });
                                          } else {
                                            DatabaseService()
                                                .addWatchlist(movie.title);
                                            setState(() {
                                              Colors.green;
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          Icons.visibility,
                                          color: isFavorite
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                              const SizedBox(width: 8.0),
                              FutureBuilder<bool>(
                                future:
                                    DatabaseService().isFavorite(movie.title),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    if (snapshot.hasError) {
                                      return const Icon(
                                        Icons.favorite,
                                        color: Colors.grey,
                                      );
                                    } else {
                                      final isFavorite = snapshot.data!;
                                      return IconButton(
                                        onPressed: () {
                                          final isFavorite = snapshot.data!;
                                          if (isFavorite) {
                                            DatabaseService()
                                                .removeFavorite(movie.title);
                                            setState(() {
                                              Colors.grey;
                                            });
                                          } else {
                                            DatabaseService()
                                                .addFavorite(movie.title);
                                            setState(() {
                                              Colors.red;
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: isFavorite
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
