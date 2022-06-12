import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:seeq_business/screens/events/event_setup.dart';
import 'package:seeq_business/utils/constants.dart';

import '../services/main_db.dart';
import '../models/event.dart';
import 'events/event_preview.dart';

class Events extends StatefulWidget {
  static const String route = '/events';

  final AppModel model;

  const Events({Key? key, required this.model}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  TabBar get _tabBar => TabBar(
        labelColor: kPrimaryColor,
        tabs: [
          Tab(text: 'Upcoming'),
          Tab(text: 'Past'),
          Tab(text: 'Draft'),
        ],
      );

  Widget appBarField = Text('Events');
  bool onSearch = false;

  @override
  void initState() {
    super.initState();
    widget.model.fetchEvent();
  }

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
            child: ColoredBox(color: Colors.blueGrey.shade200, child: _tabBar),
          ),
          title: !onSearch
              ? appBarField
              : ScopedModelDescendant<AppModel>(
                  builder: (context, child, model) {
                  List<Event> eventList = model.eventList;
                  return TextField(
                    style: TextStyle(color: kWhiteColor),
                    textInputAction: TextInputAction.search,
                    onChanged: (text) {
                      text = text.toLowerCase();

                      setState(() {
                        model.eventList = model.eventList.where((Event event) {
                          String eventName = event.name.toLowerCase();
                          // searchNotFound = false;
                          return eventName.contains(text);
                        }).toList();
                        if (model.eventList.isEmpty) {
                          // setState(() {
                          //   searchNotFound = true;
                          // });
                          print('no item ');
                        }
                        if (!onSearch) {
                          model.eventList = eventList;
                        }
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: kWhiteColor),
                        // suffixIcon: Container(
                        //   color: kPrimaryColor,
                        //   child: Icon(
                        //     Icons.search,
                        //     // color: Colors.black,
                        //   ),
                        // ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        // filled: true,
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  );
                }),
          actions: [
            IconButton(
              icon: Icon(
                onSearch ? Icons.close : Icons.search,
                color: kWhiteColor,
              ),
              onPressed: () {
                setState(() => onSearch = !onSearch);
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            EventsPage(
              widget.model,
              eventState: EventState.active,
            ),
            EventsPage(
              widget.model,
              eventState: EventState.archived,
            ),
            EventsPage(
              widget.model,
              eventState: EventState.draft,
            ),
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

enum EventState { active, archived, draft }

class EventsPage extends StatefulWidget {
  final AppModel model;
  final EventState? eventState;

  const EventsPage(this.model, {this.eventState});
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    EventState? eventState = widget.eventState;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScopedModelDescendant<AppModel>(builder: (context, child, model) {
        return RefreshIndicator(
            backgroundColor: kPrimaryColor,
            color: kSecondaryColor,
            strokeWidth: 2,
            onRefresh: () => model.fetchEvent(true),
            child: Builder(builder: (context) {
              if (eventState == EventState.archived) {
                return model.loadingEvent
                    ? Center(child: CircularProgressIndicator())
                    : model.archivedEventList.isEmpty
                        ? const EmptyList()
                        : ListView.builder(
                            itemCount: model.archivedEventList.length,
                            itemBuilder: (context, index) {
                              Event event = model.archivedEventList[index];
                              return DismissibleTile(
                                  event: event, index: index);
                            },
                          );
              } else if (eventState == EventState.draft) {
                return model.loadingEvent
                    ? const Center(child: CircularProgressIndicator())
                    : model.draftEventList.isEmpty
                        ? const EmptyList()
                        : ListView.builder(
                            itemCount: model.draftEventList.length,
                            itemBuilder: (context, index) {
                              Event event = model.draftEventList[index];
                              return DismissibleTile(
                                  event: event, index: index);
                            },
                          );
              }
              return model.loadingEvent
                  ? const Center(child: CircularProgressIndicator())
                  : model.eventList.isEmpty
                      ? const EmptyList()
                      : ListView.builder(
                          itemCount: model.eventList.length,
                          itemBuilder: (context, index) {
                            Event event = model.eventList[index];
                            return DismissibleTile(event: event, index: index);
                          },
                        );
            }));
      }),
    );
  }
}

class DismissibleTile extends StatelessWidget {
  const DismissibleTile({
    Key? key,
    required this.event,
    required this.index,
  }) : super(key: key);

  final Event event;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(event.name),

      // The start action pane is the one at the left or the top side.
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () {}),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text(
                          'This event will be deleted. This process can not be undone.'),
                      actions: [
                        TextButton(
                          child: const Text('CANCEL',
                              style: TextStyle(color: Colors.grey)),
                          onPressed: () {},
                        ),
                        ScopedModelDescendant<AppModel>(
                            builder: (context, child, model) {
                          return TextButton(
                            child: const Text('DELETE',
                                style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              model.deleteEvent('${event.id}', event.status!);
                              Navigator.pop(context);
                            },
                          );
                        })
                      ],
                    );
                  });
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),

      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventPreviewPage(event: event))),
        leading: Container(
            width: 100,
            height: 100,
            child: CachedNetworkImage(
                placeholder: (context, url) =>
                    Image(image: AssetImage('images/placeholder.png')),
                fit: BoxFit.fitWidth,
                imageUrl: '${event.coverImage}',
                errorWidget: (context, obj, stack) => Container(
                    color: Colors.grey,
                    child: Center(child: Icon(Icons.error))))),
        title: Text(event.name),
        subtitle: Text(event.type),
        trailing:
            ScopedModelDescendant<AppModel>(builder: (context, child, model) {
          return IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                model.selectIndex = index;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventSetup(event: event)));
              });
        }),
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
