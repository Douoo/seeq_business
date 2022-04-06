import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Messages extends StatelessWidget {
  static const String route = '/messages';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Text('Messages', style: TextStyle(color: kBlackColor)),
        centerTitle: true,
        elevation: 1,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/no_message.png'),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'No Messages\n\n',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold, color: kPrimaryColor),
                    ),
                    const TextSpan(
                      text:
                          'You\'ve got no messages yet. You\'ll be able to see messages sent to you from your customers',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
