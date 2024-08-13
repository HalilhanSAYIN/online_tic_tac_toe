import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.apps,
                    size: 150,
                  ),
                  Text(
                    "Welcome to TIC TAC TOE game",
                    style: TextStyle(fontSize: 24),
                  )
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                    label: Text("Nickname"), border: OutlineInputBorder()),
              ),
              ElevatedButton(
                onPressed: () {
                  signInAnonymously(context);
                },
                child: Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
