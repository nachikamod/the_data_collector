import 'package:data_collector/constants/color.dart';
import 'package:data_collector/constants/strings.dart';
import 'package:data_collector/screens/AuthScreen/CreateAccountScreen.dart';
import 'package:data_collector/screens/AuthScreen/LoginScreen.dart';
import 'package:data_collector/screens/DatasetScreen/DataScreen/DataScreen.form.dart';
import 'package:data_collector/screens/DatasetScreen/DatasetScreen.dart';
import 'package:data_collector/screens/HomeScreen/HomeScreen.dart';
import 'package:data_collector/screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  static final Map<int, Color> color = {
    50: const Color.fromRGBO(136, 14, 79, .1),
    100: const Color.fromRGBO(136, 14, 79, .2),
    200: const Color.fromRGBO(136, 14, 79, .3),
    300: const Color.fromRGBO(136, 14, 79, .4),
    400: const Color.fromRGBO(136, 14, 79, .5),
    500: const Color.fromRGBO(136, 14, 79, .6),
    600: const Color.fromRGBO(136, 14, 79, .7),
    700: const Color.fromRGBO(136, 14, 79, .8),
    800: const Color.fromRGBO(136, 14, 79, .9),
    900: const Color.fromRGBO(136, 14, 79, 1),
  };

  final MaterialColor colorScaffold =
      MaterialColor(CustomColors.APP_THEME_DARK, color);

  final MaterialColor colorSwatch =
      MaterialColor(CustomColors.ASSETS_DARK, color);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(CustomColors.APP_STATUS_BAR),
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: colorSwatch,
        scaffoldBackgroundColor: colorScaffold,
        appBarTheme: AppBarTheme(
            backgroundColor: Color(CustomColors.APP_BAR_DARK),
            titleTextStyle: const TextStyle(color: Colors.white)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        RouteStrings.ROOT: (context) => const SplashScreen(),
        RouteStrings.HOME: (context) => const HomeScreen(),
        RouteStrings.DATASET: (context) => const DatasetScreen(),
        RouteStrings.DATASET_FORM: (context) => const DataScreenForm(),
        RouteStrings.LOGIN_SCREEN: (context) => const LoginScreen(),
        RouteStrings.CREATE_ACC: (context) => const CreateAccountScreen(),
      },
    );
  }
}
