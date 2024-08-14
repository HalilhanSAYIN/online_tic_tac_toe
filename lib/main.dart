import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/screens/home_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
     const backgroundColor = Color(0xFFFEFAF0);
     const secondaryColor = Color.fromARGB(255, 124, 197, 100);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(
          background: backgroundColor,
          seedColor: secondaryColor),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

