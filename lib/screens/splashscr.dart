import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musicapp/screens/allsongsscr.dart';
class splashscr extends StatefulWidget {
  const splashscr({super.key});

  @override
  State<splashscr> createState() => _splashscrState();
}

class _splashscrState extends State<splashscr> {
  void  initState(){
    super.initState();
    Timer(Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> allsongs()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset("assets/animations/musicapp.json"),
          ),
        ],
      )
    );
  }
}
