import 'package:flutter/material.dart';
import 'package:seeq_business/components/buttons.dart';
import 'package:seeq_business/screens/sms_verification.dart';
import 'package:seeq_business/utils/constants.dart';
import 'package:seeq_business/utils/size_config.dart';

import 'login.dart';

class OnBoardingPage extends StatefulWidget {
  static const String route = '/on_boarding';

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage('images/app_logo.png'))),
                ),
              ),
              Expanded(
                flex: -1,
                child: RoundButton(
                    onTap: () => Navigator.pushNamed(context, Login.route),
                    color: kWhiteColor,
                    textColor: kPrimaryColor,
                    title: 'Cinema Manager'),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              Expanded(
                flex: -1,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, Login.route),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
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
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
