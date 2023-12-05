import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_assignment/Screens/bg.dart';
import 'package:task_manager_assignment/login_Signup/login.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {

  void initState(){
    super.initState();
    GoLogin();
  }

  void GoLogin() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const login()),
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: background(
        child:
          Center(
            child:
            SvgPicture.asset(
              'assets/logo.svg',
            ),
          ),
      )
    );
  }
}
