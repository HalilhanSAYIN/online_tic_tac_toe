import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/screens/game_list_screen.dart';
import 'package:online_tic_tac_toe/screens/home_screen.dart';
import 'package:online_tic_tac_toe/services/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<bool> checkUserStatus() async {
    Map<String, String?> userData = await getUserData();
    if (userData['uuid'] != null && userData['nickname'] != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    checkUserStatus().then((value) {
      if (value == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GamesListScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/logo.png", width: 300,height: 300,)
      ),
    );
  }
}
