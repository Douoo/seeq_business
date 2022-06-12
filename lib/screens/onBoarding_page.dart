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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: PageView.builder(
              onPageChanged: (int value) {
                setState(() {
                  dotIndicator = value;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return ShowCaseContainer(
                  image: showCaseInfo[index]['image'],
                  title: showCaseInfo[index]['title'],
                  description: showCaseInfo[index]['description'],
                  color: showCaseInfo[index]['color'],
                );
              },
              itemCount: showCaseInfo.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(showCaseInfo.length,
                  (index) => buildShowCaseDots(index: index)),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text('Manage your events on the go!',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center),
          )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundButton(
                    onTap: () => Navigator.pushNamed(context, Login.route),
                    color: kPrimaryColor,
                    textColor: kWhiteColor,
                    title: 'Cinema Manager',
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, Login.route),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: const Text(
                        'Event Organizer',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      primary: kPrimaryColor,
                      side: const BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildShowCaseDots({int? index}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: dotIndicator == index ? kPrimaryColor : Colors.grey),
    );
  }
}

class ShowCaseContainer extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;
  final Color? color;

  // ignore: use_key_in_widget_constructors
  const ShowCaseContainer(
      {this.image, this.title, this.description, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Spacer(),
          RichText(
            softWrap: true,
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title\n\n',
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(24),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: description,
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          SizedBox(
            height: getProportionateScreenHeight(200),
            width: double.infinity,
            child: Image(
              image: AssetImage(image!),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
        ],
      ),
    );
  }
}
