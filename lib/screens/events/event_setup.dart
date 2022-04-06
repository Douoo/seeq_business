import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seeq_business/utils/size_config.dart';

import '../../utils/constants.dart';

class EventSetup extends StatefulWidget {
  static const String route = '/event_setup';
  @override
  _EventSetupState createState() => _EventSetupState();
}

class _EventSetupState extends State<EventSetup> {
  final _formKey = GlobalKey<FormState>();

  final _startDateInput = TextEditingController();
  final _endDateInput = TextEditingController();
  final _startTimeInput = TextEditingController();
  final _endTimeInput = TextEditingController();
  final _ticketQuantityInput = TextEditingController();

  FocusNode _focusOnTitle = FocusNode();
  FocusNode _focusOnDescription = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: kPrimaryColor,
        title: Text("Create event"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.visibility),
            onPressed: () {
              //TODO: Save event
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              //TODO: Save event
            },
          ),
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
        ],
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.grey,
                  child: Icon(
                    Icons.image_outlined,
                    size: 50,
                    color: kWhiteColor,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          TextFormField(
                            onFieldSubmitted: (submitted) {
                              // FocusScope.of(context).requestFocus();
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Event title',
                                icon: Icon(Icons.short_text_outlined)),
                          ),
                          // DropdownButtonFormField(
                          //   icon: Icon(Icons.location_pin),
                          //   hint: Text('Choose a place'),
                          //   items: [
                          //     DropdownMenuItem(
                          //       value: 'Venue',
                          //       child: Text('Venue'),
                          //     ),
                          //     DropdownMenuItem(
                          //       value: 'Online',
                          //       child: Text('Online'),
                          //     ),
                          //     DropdownMenuItem(
                          //       value: 'To be announced',
                          //       child: Text('To be announced'),
                          //     ),
                          //   ],
                          //   onChanged: (value) {},
                          // ),
                          TextFormField(
                            onFieldSubmitted: (submitted) {
                              // FocusScope.of(context).requestFocus();
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              labelText: 'Place*',
                              icon: Icon(Icons.location_pin),
                            ),
                          ),
                          TextFormField(
                            onFieldSubmitted: (submitted) {
                              // FocusScope.of(context).requestFocus();
                            },
                            maxLines: 5,
                            decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Description',
                                icon: Icon(Icons.text_snippet_outlined)),
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _startDateInput,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      labelText: "Event starts"),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101));

                                    if (pickedDate != null) {
                                      print(pickedDate);
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      print(formattedDate);

                                      setState(() {
                                        _startDateInput.text =
                                            formattedDate; //set output date to TextField value.
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _startTimeInput,
                                  decoration:
                                      InputDecoration(labelText: "Start time"),
                                  readOnly: true,
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );

                                    if (pickedTime != null) {
                                      print(pickedTime.format(context));
                                      DateTime parsedTime = DateFormat.jm()
                                          .parse(pickedTime
                                              .format(context)
                                              .toString());
                                      print(parsedTime);
                                      String formattedTime =
                                          DateFormat('HH:mm:ss')
                                              .format(parsedTime);
                                      print(formattedTime);

                                      setState(() {
                                        _startTimeInput.text = formattedTime;
                                      });
                                    } else {
                                      print("Time is not selected");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _endDateInput,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.calendar_today,
                                          color: Colors.transparent),
                                      labelText: "Event ends"),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101));

                                    if (pickedDate != null) {
                                      print(pickedDate);
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      print(formattedDate);

                                      setState(() {
                                        _endDateInput.text = formattedDate;
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _endTimeInput,
                                  decoration:
                                      InputDecoration(labelText: "End time"),
                                  readOnly: true,
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );

                                    if (pickedTime != null) {
                                      print(pickedTime.format(context));
                                      DateTime parsedTime = DateFormat.jm()
                                          .parse(pickedTime
                                              .format(context)
                                              .toString());
                                      print(parsedTime);
                                      String formattedTime =
                                          DateFormat('HH:mm:ss')
                                              .format(parsedTime);
                                      print(formattedTime);

                                      setState(() {
                                        _endTimeInput.text = formattedTime;
                                      });
                                    } else {
                                      print("Time is not selected");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: _endTimeInput,
                            decoration: InputDecoration(
                              labelText: "Event type",
                              icon: Icon(Icons.tag_outlined),
                            ),
                            readOnly: true,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        child: Container(
                                      height: getProportionateScreenHeight(600),
                                      child: ListView(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              'Select event type',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                    color: kBlackColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                                  });
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Quantity",
                              icon: Icon(
                                Icons.sell_outlined,
                              ),
                            ),
                          )
                          // ListTile(
                          //     leading: Icon(Icons.sell),
                          //     title: Text('Tickets'),
                          //     subtitle: Text(
                          //         'Customize how you tend to sell your tickets'))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
