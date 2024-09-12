import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cat_breeds_app/ui/screens/home_screen.dart';
import 'package:cat_breeds_app/services/services.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CatBreedsProvider(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cat Breeds',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}
