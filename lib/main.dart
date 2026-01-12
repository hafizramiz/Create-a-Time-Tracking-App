import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'provider/time_entry_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TimeEntryProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF458B7D),
          primary: const Color(0xFF458B7D),
          secondary: const Color(0xFF4B1D6E),
          tertiary: const Color(0xFFF0C84B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF458B7D),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF0C84B),
          foregroundColor: Colors.black54,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
