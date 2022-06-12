import 'package:flutter/material.dart';

import '../components/empty_data.dart';
import '../utils/constants.dart';

class Messages extends StatelessWidget {
  static const String route = '/messages';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Text(
          'Messages',
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          EmptyData(
            description:
                "You've got no messages yet. You\'ll be able to see messages sent to you from your customers",
            image: 'images/no_message.png',
            title: 'No Messages',
          ),
        ],
      ),
    );
  }
}
