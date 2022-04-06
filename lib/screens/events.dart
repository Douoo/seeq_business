import 'package:flutter/material.dart';
import 'package:seeq_business/screens/events/event_setup.dart';
import 'package:seeq_business/utils/constants.dart';

class Events extends StatelessWidget {
  static const String route = '/events';

  TabBar get _tabBar => TabBar(
        labelColor: kPrimaryColor,
        tabs: [
          Tab(text: 'Upcoming'),
          Tab(text: 'Past'),
          Tab(text: 'Draft'),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            automaticallyImplyLeading: false,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            elevation: 1,
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child:
                  ColoredBox(color: Colors.blueGrey.shade200, child: _tabBar),
            ),
            title: Text('Events')),
        body: const TabBarView(
          children: [
            EmptyList(),
            EmptyList(),
            EmptyList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kSecondaryColor,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, EventSetup.route);
          },
        ),
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  const EmptyList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Image(
              image: AssetImage('images/no_data.png'),
            ),
            Container(
              width: 300,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'No Events Yet\n',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold, color: kPrimaryColor),
                    ),
                    const TextSpan(
                      text:
                          "You'll be able to see, view and manage all of your events here.",
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ColoredTabBar extends ColoredBox implements PreferredSizeWidget {
  ColoredTabBar({required this.color, this.tabBar})
      : super(color: color, child: tabBar);

  final Color color;
  final TabBar? tabBar;

  @override
  Size get preferredSize => tabBar!.preferredSize;
}
