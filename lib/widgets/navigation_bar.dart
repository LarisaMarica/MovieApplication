import 'package:flutter/material.dart';
import 'package:netflix/screens/account_screen.dart';
import 'package:netflix/screens/favorites_screen.dart';
import 'package:netflix/screens/form_screen.dart';
import 'package:netflix/screens/home_screen.dart';
import 'package:netflix/screens/movies_screen.dart';
import 'package:netflix/screens/seen_screen.dart';
import 'package:netflix/screens/series_screen.dart';
import 'package:netflix/services/auth.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.amber,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text(
              'Netflix',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
            },
          ),
          ListTile(
            title: const Text('Movies'),
            leading: const Icon(Icons.movie),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MoviesScreen(),
              ));
            },
          ),
          ListTile(
            title: const Text('Series'),
            leading: const Icon(Icons.tv),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SeriesScreen(),
              ));
            },
          ),
          ListTile(
            title: const Text('Watch List'),
            leading: const Icon(Icons.list),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SeenScreen(),
              ));
            },
          ),
          ListTile(
            title: const Text('Favorites'),
            leading: const Icon(Icons.favorite),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FavoritesScreen(),
              ));
            },
          ),
          ListTile(
            title: const Text('Account'),
            leading: const Icon(Icons.account_circle),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MyAccount(),
              ));
            },
          ),
          const Divider(
            color: Colors.white,
            height: 10,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                await AuthService().signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FormScreen()),
                );
              })
        ],
      ),
    );
  }
}
