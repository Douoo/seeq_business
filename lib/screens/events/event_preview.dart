import 'package:flutter/material.dart';
import 'package:seeq_business/models/event.dart';

import '../../utils/constants.dart';

class EventPreviewPage extends StatelessWidget {
  final Event event;

  EventPreviewPage({required this.event});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        // actions: [
        // PopupMenuButton(
        //   initialValue: 2,
        //   itemBuilder: (BuildContext context) {
        //     return [
        //       PopupMenuItem(
        //         value: 'index',
        //         child: Text('button no '),
        //       )
        //     ];
        //   },
        // )
        // ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  image: DecorationImage(
                    image: NetworkImage('${event.coverImage}'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: kBlackColor, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      // Row(
                      //   children: [
                      //     Icon(Icons.location_pin),
                      //     Text('${event.location}')
                      //   ],
                      // ),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey),
                          children: [
                            TextSpan(text: 'Ticket is available for free\n'),
                            TextSpan(
                              text: 'Date - ${event.startDate}\n\n',
                            ),
                            TextSpan(
                                text: event.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
