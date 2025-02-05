import 'package:flutter/material.dart';
import 'package:tic_tac_game/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff00061a),
        shadowColor:Color(0xff001456),
        splashColor: Color(0xff4169e8),
      ),
      home: HomeScreen(),
    );
  }
}
