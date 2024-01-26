import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:netflix/screens/form_screen.dart';
import 'package:netflix/services/auth.dart';
import 'package:netflix/services/database.dart';
import 'package:netflix/services/firebase_api.dart';
import 'services/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await FirebaseApi().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseService().loadMoviesIntoFirestore();
    DatabaseService().loadSeriesIntoFirestore();

    return StreamProvider.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
          title: 'Movie Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
            useMaterial3: true,
          ),
          home: const FormScreen()),
    );
  }
}
