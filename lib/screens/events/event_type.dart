import 'package:flutter/material.dart';
import 'package:seeq_business/components/app_bar.dart';

class CreateEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElevatedAppBar(title: 'Create Event', showBackButton: true),
      body: Column(children: [
        ListTile(
          leading: Icon(Icons.price_change),
        )
      ]),
    );
  }
}
