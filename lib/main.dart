import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/provider/comments_provider.dart';
import 'package:newsapp/provider/auth_provider.dart';
import 'package:newsapp/screens/comments_screen.dart';
import 'package:newsapp/screens/signup_screen.dart';
import 'package:newsapp/utils/widgets.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => CommentsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF5F9FD),
          fontFamily: GoogleFonts.poppins().fontFamily,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F9FD),
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0C54BE),
            secondary: Color(0xFFCED3DC),
            tertiary: Color(0xFFF5F9FD),
          ),
          textTheme: const TextTheme(
              titleLarge: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C54BE),
              ),
              titleMedium: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titleSmall: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              bodyMedium: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              bodyLarge: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              bodySmall: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xFFCED3DC),
                fontStyle: FontStyle.italic,
              )),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: CustomLoadigIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return const CommentsScreen();
              } else {
                return const SignupScreen();
              }
            }
          },
        ),
      ),
    );
  }
}
