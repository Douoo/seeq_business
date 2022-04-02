import 'package:flutter/material.dart';
import 'package:seeq_business/components/buttons.dart';

import 'utils/constants.dart';

void main() {
  runApp(const SeeqBusiness());
}

class SeeqBusiness extends StatelessWidget {
  const SeeqBusiness({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugShowCheckedModeBanner:
    false;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: OnBoardingPage.route,
      routes: {
        OnBoardingPage.route: (context) => OnBoardingPage(),
        //TODO: Setup the routes here
      },
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  static const String route = '/on_boarding';

  @override
  State<OnBoardingPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 10),
            const Image(
              image: AssetImage('images/Brandmark.png'),
            ),
            Spacer(),
            RoundButton(
                onTap: () {
                  //TODO: Navigate to cinema
                },
                color: kWhiteColor,
                textColor: kPrimaryColor,
                title: 'Cinema Manager'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: OutlinedButton(
                onPressed: () {
                  //TODO: Navigate to event organizer
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Event Organizer',
                    style: TextStyle(color: kWhiteColor),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  primary: kWhiteColor,
                  side: const BorderSide(color: kWhiteColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
