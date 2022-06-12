import 'package:flutter/material.dart';
import 'package:seeq_business/components/empty_data.dart';

import '../utils/constants.dart';
import 'sales/sales_data.dart';

class Sales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          title: Text('Sales'),
          centerTitle: true,
        ),
        body: true
            ? LineChartSample2()
            : EmptyData(
                image: 'images/no-data-report.png',
                title: 'No transactions',
                description:
                    "You've got no transactions yet. You'll see all of your event sales statistics"));
  }
}
