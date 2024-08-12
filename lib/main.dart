import 'package:flutter/material.dart';
import 'package:musicapp/screens/allsongsscr.dart';
import 'package:musicapp/screens/splashscr.dart';

void main() {
  runApp(myapp());
}
class myapp extends StatelessWidget {
  const myapp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Music Player",
      theme: ThemeData.dark(),
      home: splashscr(),
    );
  }
}
