import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'data/database/database.dart';
import 'data/repositories/trip_repository.dart';
import 'screens/home_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final database = AppDatabase.getInstance();
  final tripRepository = TripRepository(database);
  
  runApp(MyApp(tripRepository: tripRepository));
}

class MyApp extends StatelessWidget {
  final TripRepository tripRepository;

  const MyApp({super.key, required this.tripRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frenzi Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A237E)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: SplashScreen(),
    );
  }
}
