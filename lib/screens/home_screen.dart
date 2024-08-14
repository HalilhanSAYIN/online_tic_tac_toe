import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_tic_tac_toe/screens/game_create_screen.dart';
import 'package:online_tic_tac_toe/screens/game_list_screen.dart';
import 'package:online_tic_tac_toe/widgets/dialogs/logout_dialog.dart';

class HomeScreen extends StatelessWidget {
  final String nickName; 
   HomeScreen({super.key , required this.nickName});

  @override
  
  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final pageHeiht = MediaQuery.of(context).size.height;
   
    
    const backgroundColor = Color(0xFFFEFAF0);
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Tic Tac Toe'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      "Welcome ${nickName}",
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  Icon(
                    Icons.waving_hand_outlined,
                    color: Colors.amber[500],
                    size: 100,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGameScreen(),));
                },
                child: Card(
                  child: SizedBox(
                    width: pageWidth * 0.8,
                    height: pageHeiht * 0.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: pageHeiht * 0.1,
                        ),
                        Text("New Game", style: TextStyle(fontSize: 32))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => GamesListScreen(),));
                },
                child: Card(
                  child: SizedBox(
                    width: pageWidth * 0.8,
                    height: pageHeiht * 0.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list,
                          size: pageHeiht * 0.1,
                        ),
                        Text("Game List", style: TextStyle(fontSize: 32))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  showLogOutDialog(context);
                },
                icon: const Icon(Icons.logout))
          ],
        ));
  }
}
