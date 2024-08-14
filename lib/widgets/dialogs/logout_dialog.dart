
  import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/services/shared_pref.dart';

Future<dynamic> showLogOutDialog(BuildContext context) {
    return showDialog(context: context, builder: (context) {
             return AlertDialog(
              title: Text("Attention"),
              content: Text("Are you sure you want to log out? Registered user data will be deleted."),
              actions: [
                ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text("Cancel")),
                 ElevatedButton(onPressed: () {
                   clearUserData(context);
                }, child: Text("Log Out"))
              ],
             );
           },);
  }

