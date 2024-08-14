import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/services/auth.dart';

final nickNameTextEditingController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    const backgroundColor = Color(0xFFFEFAF0);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      width: 300,
                      height: 300,
                    ),
                    const Text(
                      "TIC TAC TOE",
                      style: TextStyle(fontSize: 24),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 24.0),
                  child: SizedBox(
                    width: pageWidth * 0.7,
                    child: TextFormField(
                      controller: nickNameTextEditingController,
                      decoration: const InputDecoration(
                          label: Text("Nickname"),
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 10),
                  onPressed: () {
                    if (nickNameTextEditingController.text == "" ||
                        nickNameTextEditingController.text.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                          content:
                              Text("Nickname must be at least 3 characters!")));
                    } else {
                      signInAnonymously(
                          context, nickNameTextEditingController.text);
                    }
                  },
                  child: const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.play_arrow_sharp,
                          size: 72,
                        ),
                         Text(
                          'Sign In',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}