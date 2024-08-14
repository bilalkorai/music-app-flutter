import 'package:flutter/material.dart';
import 'package:musicapp/screens/allsongsscr.dart';
import 'package:musicapp/screens/splashscr.dart';

void main() {
  runApp(myapp());
}
class myapp extends StatefulWidget {
  const myapp({super.key});

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {

  bool isdarktheme = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Music Player",
      theme: isdarktheme ? ThemeData.dark() : ThemeData.light(),
      home: splashscr(onThemeChanged: onthemechange,),
    );
  }
  void onthemechange(){
    setState(() {
      isdarktheme = !isdarktheme;
    });
  }
}
