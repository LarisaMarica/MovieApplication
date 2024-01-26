import 'package:flutter/material.dart';
import 'package:netflix/models/movie.dart';
import 'package:netflix/services/database.dart';
import 'package:netflix/widgets/navigation_bar.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  late List<Movie> seriesList = [];
  TextEditingController searchController = TextEditingController();
  late List<Movie> filteredSeriesList = [];

  @override
  void initState() {
    super.initState();
    DatabaseService().getSeries().then((series) {
      setState(() {
        seriesList = series;
      });
    });
  }

  void filterSeries(value) {
    setState(() {
      filteredSeriesList = seriesList
          .where((serie) =>
              serie.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Series'),
        centerTitle: true,
      ),
      drawer: const NavigationDrawerWidget(),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                        hintText: 'Search for a series',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      filterSeries(searchController.text);
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              Expanded(
                child: filteredSeriesList.isEmpty &&
                        searchController.text.isNotEmpty
                    ? const Center(
                        child: Text('No series found'),
                      )
                    : ListView.builder(
                        itemCount: filteredSeriesList.isNotEmpty
                            ? filteredSeriesList.length
                            : seriesList.length,
                        itemBuilder: (context, index) {
                          Movie serie = filteredSeriesList.isNotEmpty
                              ? filteredSeriesList[index]
                              : seriesList[index];

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        serie.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        serie.director.isEmpty
                                            ? 'Director: Unknown'
                                            : 'Director: ${serie.director}',
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Text(serie.release_year.isNaN
                                          ? 'Release Year: Unknown'
                                          : 'Release Year: ${serie.release_year}'),
                                      Text(serie.country.isEmpty
                                          ? 'Country: Unknown'
                                          : 'Country: ${serie.country}'),
                                      Text(serie.rating.isEmpty
                                          ? 'Rating: Unknown'
                                          : 'Rating: ${serie.rating}'),
                                      Text(serie.duration.isEmpty
                                          ? 'Duration: Unknown'
                                          : 'Duration: ${serie.duration}'),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(serie.description),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FutureBuilder<bool>(
                                        future: DatabaseService()
                                            .isWatched(serie.title),
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
                                                  final isSeen = snapshot.data!;
                                                  if (isSeen) {
                                                    DatabaseService()
                                                        .removeWatchlist(
                                                            serie.title);
                                                    setState(() {
                                                      Colors.grey;
                                                    });
                                                  } else {
                                                    DatabaseService()
                                                        .addWatchlist(
                                                            serie.title);
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
                                        future: DatabaseService()
                                            .isFavorite(serie.title),
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
                                                  final isFavorite =
                                                      snapshot.data!;
                                                  if (isFavorite) {
                                                    DatabaseService()
                                                        .removeFavorite(
                                                            serie.title);
                                                    setState(() {
                                                      Colors.grey;
                                                    });
                                                  } else {
                                                    DatabaseService()
                                                        .addFavorite(
                                                            serie.title);
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
              )
            ],
          )),
    );
  }
}
