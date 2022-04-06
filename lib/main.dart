import 'package:flutter/material.dart';

import 'screens/events.dart';
import 'screens/events/event_setup.dart';
import 'screens/main_menu.dart';
import 'screens/onBoarding_page.dart';
import 'screens/login.dart';
import 'screens/profile_setup.dart';
import 'screens/sms_verification.dart';

void main() {
  runApp(const SeeqBusiness());
}

class SeeqBusiness extends StatelessWidget {
  const SeeqBusiness({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seeq Partner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: OnBoardingPage.route,
      routes: {
        OnBoardingPage.route: (context) => OnBoardingPage(),
        Login.route: (context) => Login(),
        MainMenu.route: (context) => MainMenu(),
        VerifySMS.route: (context) => VerifySMS(),
        Events.route: (context) => Events(),
        EventSetup.route: (context) => EventSetup(),
        ProfileSetup.route: (context) => ProfileSetup()
      },
    );
  }
}
