// ignore_for_file: file_names

import 'package:data_collector/constants/strings.dart';
import 'package:data_collector/services/db.service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DBService db = DBService();

  @override
  void initState() {
    super.initState();

    // jump to home page after 2 seconds
    Future.delayed(const Duration(seconds: 2), () async {

      int len = await db.checkUser();

      if (len == 0) {

        Navigator.of(context).pushReplacementNamed(RouteStrings.CREATE_ACC);

      }

      else {

        Navigator.of(context).pushReplacementNamed(RouteStrings.LOGIN_SCREEN);

      }

      //Navigator.of(context).pushReplacementNamed(RouteStrings.HOME);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'DC',
          style: TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.w600,
              letterSpacing: 3),
        ),
      ),
    );
  }
}
