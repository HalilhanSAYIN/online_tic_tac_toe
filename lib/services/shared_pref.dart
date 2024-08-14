import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserData(String uuid, String nickname) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('uuid', uuid);
  await prefs.setString('nickname', nickname);
}

Future<Map<String, String?>> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? uuid = prefs.getString('uuid');
  String? nickname = prefs.getString('nickname');
  return {'uuid': uuid, 'nickname': nickname};
}

Future<void> clearUserData(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('uuid');
  await prefs.remove('nickname');

   Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),(route) => false,);
}