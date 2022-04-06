import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/size_config.dart';
import 'events.dart';

class Dashboard extends StatelessWidget {
  static const String route = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Dashboard', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
              icon: Icon(Icons.notifications_outlined, color: kBlackColor),
              onPressed: () {
                //TODO: Navigate to notification
              })
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey,
                margin: EdgeInsets.all(8)),
            Row(
              children: [
                Expanded(
                  child: RoundBoxes(
                    onPress: () {
                      Navigator.pushNamed(context, Events.route);
                    },
                    child: IconContent(icon: Icons.event, text: 'Events'),
                  ),
                ),
                Expanded(
                  child: RoundBoxes(
                    onPress: () {},
                    child: IconContent(
                        icon: Icons.analytics_outlined, text: 'Sales'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IconContent extends StatelessWidget {
  const IconContent({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 80,
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.02),
        Text(text),
      ],
    );
  }
}

class RoundBoxes extends StatelessWidget {
  const RoundBoxes({
    Key? key,
    required this.onPress,
    this.color,
    this.child,
  }) : super(key: key);

  final Function() onPress;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: child,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0.2,
                blurRadius: 0.5,
                offset: Offset(0, 2),
              )
            ],
            color: color ?? kWhiteColor,
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
