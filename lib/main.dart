import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('logged_in') ?? false;
  final initalRoute = isLoggedIn ? '/home' : '/login';
  runApp(MyApp(initialRoute: initalRoute,));
}
