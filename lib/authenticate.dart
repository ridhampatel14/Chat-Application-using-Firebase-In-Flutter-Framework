import 'package:chat_application/screen/home_screen.dart';
import 'package:chat_application/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class authenticate extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _authenticateState();
  }
}

class _authenticateState extends State<authenticate>{
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if(_auth.currentUser!=null){
      return HomeScreen();
    }
    else{
      return LoginScreen();
    }
  }
}