import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:seeq_business/models/event.dart';
import 'package:seeq_business/utils/size_config.dart';

import '../../components/buttons.dart';
import '../../models/ticket.dart';
import '../../services/cloud_storage.dart';
import '../../services/main_db.dart';
import '../../utils/constants.dart';
import '../main_menu.dart';
import 'add_ticket.dart';

class EventSetup extends StatefulWidget {
  static const String route = '/event_setup';

  final Event? event;

  const EventSetup({Key? key, this.event}) : super(key: key);
  @override
  _EventSetupState createState() => _EventSetupState();
}

class _EventSetupState extends State<EventSetup> {
  final _formKey = GlobalKey<FormState>();
  CloudStorageService _cloudStorageService = CloudStorageService();
  bool _isLoading = false;

  final _eventTitle = TextEditingController();
  final _place = TextEditingController();
  final _description = TextEditingController();
  final _eventType = TextEditingController();

  final _startDateInput = TextEditingController();
  final _endDateInput = TextEditingController();
  final _startTimeInput = TextEditingController();
  final _endTimeInput = TextEditingController();

  FocusNode _focusOnTitle = FocusNode();
  FocusNode _focusOnDescription = FocusNode();

  final Map<String, dynamic> eventDetail = {
    'name': '',
    'picture_url': '',
    'description': '',
    'place': '',
    'start': {
      'date': '',
      'time': '',
    },
    'end': {
      'date': '',
      'time': '',
    },
    'category': '',
    'status': '',
    'ticket_availability': {
      'currency': 'ETB',
      'tickets': [],
    },
  };

  final cloudinary = CloudinaryPublic('dqminndjm', 'u8fstdwf', cache: false);
  // late List<Ticket> _tickets;

  File? _image;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        Navigator.pop(context);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imagePickDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'UPLOAD IMAGE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(),
              TextButton(
                child: Text(
                  'CAMERA',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  getImage(ImageSource.camera);
                },
              ),
              TextButton(
                child: Text(
                  'GALLERY',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    _eventTitle.text = '${event?.name ?? ''}';
    _place.text = '${event?.place ?? ''}';
    _description.text = '${event?.description ?? ''}';
    _eventType.text = '${event?.type ?? ''}';
    _startDateInput.text = '${event?.startDate ?? ''}';
    _endDateInput.text = '${event?.endDate ?? ''}';
    _startTimeInput.text = '${event?.startTime ?? ''}';
    _endTimeInput.text = '${event?.endTime ?? ''}';
    _place.text = '${event?.place ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final ticketList = ScopedModel.of<AppModel>(context).tickets;

    SizeConfig().init(context);
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      color: kSecondaryColor,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: kPrimaryColor,
          // title: Text('CREATE EVENT'),
          actions: [
            IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Save event'),
                        content: Text(
                            'You need to save this event before you can preview it.'),
                        actions: [
                          TextButton(
                            child: Text('CANCEL',
                                style: TextStyle(color: Colors.red)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ScopedModelDescendant<AppModel>(
                              builder: (context, child, model) {
                            return TextButton(
                              child: Text('SAVE',
                                  style: TextStyle(color: kPrimaryColor)),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  CloudinaryResponse response;
                                  try {
                                    if (_image == null) {
                                      model
                                          .addEvent(
                                              name: _eventTitle.text,
                                              description: _description.text,
                                              picture: '',
                                              startDate: _startDateInput.text,
                                              startTime: _startTimeInput.text,
                                              endDate: _endDateInput.text,
                                              endTime: _endTimeInput.text,
                                              type: _eventType.text,
                                              status: 'draft',
                                              ticket: ticketList)
                                          .then((_) => Navigator.pushNamed(
                                              context, MainMenu.route));
                                    } else {
                                      response = await cloudinary.uploadFile(
                                        CloudinaryFile.fromFile(_image!.path,
                                            resourceType:
                                                CloudinaryResourceType.Image),
                                      );

                                      model
                                          .addEvent(
                                              name: _eventTitle.text,
                                              description: _description.text,
                                              picture: response.secureUrl,
                                              startDate: _startDateInput.text,
                                              startTime: _startTimeInput.text,
                                              endDate: _endDateInput.text,
                                              endTime: _endTimeInput.text,
                                              type: _eventType.text,
                                              status: 'draft',
                                              ticket: ticketList)
                                          .then((_) => Navigator.pushNamed(
                                              context, MainMenu.route));
                                    }
                                  } on CloudinaryException catch (e) {
                                    print(e.message);
                                    print(e.request);
                                  }
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          })
                        ],
                      );
                    });
              },
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                //TODO: Save event
              },
            ),
            ScopedModelDescendant<AppModel>(builder: (context, child, model) {
              return PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                        value: 'Delete Event',
                        child: Text(
                          'Delete event',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onTap: () {}),
                    PopupMenuItem(
                      value: 'index',
                      child: Text('Save as draft'),
                      onTap: () async {
                        CloudinaryResponse response;
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          try {
                            response = await cloudinary.uploadFile(
                              CloudinaryFile.fromFile(_image!.path,
                                  resourceType: CloudinaryResourceType.Image),
                            );

                            model
                                .addEvent(
                                    name: _eventTitle.text,
                                    description: _description.text,
                                    picture: response.secureUrl,
                                    startDate: _startDateInput.text,
                                    startTime: _startTimeInput.text,
                                    endDate: _endDateInput.text,
                                    endTime: _endTimeInput.text,
                                    type: _eventType.text,
                                    status: 'draft',
                                    ticket: ticketList)
                                .then((_) => Navigator.pushNamed(
                                    context, MainMenu.route));
                          } on CloudinaryException catch (e) {
                            print(e.message);
                            print(e.request);
                          }
                        }
                      },
                    )
                  ];
                },
              );
            })
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: GestureDetector(
                  onTap: () {
                    imagePickDialog(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          // color: Colors.grey,

                          image: _image == null && event?.coverImage == null
                              ? const DecorationImage(
                                  image: AssetImage('images/placeholder.png'),
                                  fit: BoxFit.fitWidth)
                              : _image == null
                                  ? DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image:
                                          NetworkImage('${event!.coverImage}'),
                                    )
                                  : DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: FileImage(_image!),
                                    )),
                      child: _image == null && event?.coverImage == null
                          ? const Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: kBlackColor,
                            )
                          : null),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _eventTitle,
                            onFieldSubmitted: (submitted) {
                              // FocusScope.of(context).requestFocus();
                            },
                            onSaved: (value) {
                              eventDetail['name'] = value;
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
                          //   onSaved: (value) {},
                          // ),
                          TextFormField(
                            controller: _place,
                            onFieldSubmitted: (submitted) {
                              // FocusScope.of(context).requestFocus();
                            },
                            onSaved: (value) {
                              eventDetail['place'] = value;
                              //TODO: Add place
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              labelText: 'Place*',
                              icon: Icon(Icons.location_pin),
                            ),
                          ),
                          TextFormField(
                            controller: _description,
                            onFieldSubmitted: (submitted) {
                              // FocusScope.of(context).requestFocus();
                            },
                            onSaved: (value) {
                              eventDetail['description'] = value;
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
                                  onSaved: (value) {
                                    print('a ${_startDateInput.text}');
                                    // eventDetail['start']['date'] = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field is required';
                                    }
                                    return null;
                                  },
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
                                          DateFormat('E MMM yyyy')
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
                                  onSaved: (value) {
                                    // eventDetail['start']['time'] = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field is required';
                                    }
                                    return null;
                                  },
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
                                  onSaved: (value) {
                                    // eventDetail['end']['date'] = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field is required';
                                    }
                                    return null;
                                  },
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
                                      String formattedDate =
                                          DateFormat('E MMM yyyy')
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
// controller: _endTimeInput,
                                  controller: _endTimeInput,
                                  onSaved: (value) {
                                    // eventDetail['end']['time'] = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field is required';
                                    }
                                    return null;
                                  },
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
                            controller: _eventType,
                            onSaved: (value) {
                              eventDetail['category'] = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Event type",
                              icon: Icon(Icons.sell_outlined),
                            ),
                            readOnly: true,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        child: Container(
                                      height: getProportionateScreenHeight(600),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              'Select event type',
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                    color: kBlackColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.separated(
                                              itemCount: eventCategories.length,
                                              itemBuilder: (context, index) {
                                                String category =
                                                    eventCategories[index];
                                                IconData categoryIcon =
                                                    categoryIcons[index];
                                                return ListTile(
                                                  leading: Icon(categoryIcon),
                                                  title: Text(category),
                                                  onTap: () {
                                                    setState(() => _eventType
                                                        .text = category);
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18.0),
                                                child: Divider(),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                                  });
                            },
                          ),

                          ListTile(
                            leading: Icon(
                              Icons.book_online_outlined,
                            ),
                            title: Text('Tickets'),
                            subtitle: Text(event?.tickets != null
                                ? "${event!.tickets!.length} tickets"
                                : 'Customize how you sell your tickets'),
                            onTap: () async {
                              print('tickets ${event?.tickets}');
                              final addedTickets = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddTicket(tickets: event?.tickets)));
                              // final addedTickets = await Navigator.pushNamed(
                              //     context, AddTicket.route,
                              //     arguments: event?.tickets);
                              if (addedTickets != null) {
                                // _tickets = addedTickets as List<Ticket>;
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: ScopedModelDescendant<AppModel>(
          builder: (context, child, model) {
            return Material(
              color: kBlackColor,
              child: MaterialButton(
                  color: kBlackColor,
                  child: Text(
                      event?.id == null ? 'CREATE EVENT' : 'UPDATE EVENT',
                      style: TextStyle(color: kWhiteColor)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() => _isLoading = true);
                      CloudinaryResponse response;
                      try {
                        if (event?.id != null) {
                          if (_image != null) {
                            response = await cloudinary.uploadFile(
                              CloudinaryFile.fromFile(_image!.path,
                                  resourceType: CloudinaryResourceType.Image),
                            );
                            setState(() => eventDetail['picture_url'] =
                                response.secureUrl);
                          } else {
                            setState(() => eventDetail['picture_url'] =
                                '${event!.coverImage}');
                          }
                          final _auth = FirebaseAuth.instance;
                          Event eventUpdated = Event(
                              id: event!.id,
                              name: _eventTitle.text,
                              description: _description.text,
                              coverImage: event.coverImage,
                              startDate: _startDateInput.text,
                              startTime: _startTimeInput.text,
                              endDate: _endDateInput.text,
                              endTime: _endTimeInput.text,
                              organizersID: _auth.currentUser!.uid,
                              tickets: event.tickets,
                              place: _place.text,
                              type: _eventType.text,
                              status: event.status);
                          model.updateEvent(eventUpdated);
                        } else {
                          response = await cloudinary.uploadFile(
                            CloudinaryFile.fromFile(_image!.path,
                                resourceType: CloudinaryResourceType.Image),
                          );
                          model.addEvent(
                              name: _eventTitle.text,
                              description: _description.text,
                              picture: response.secureUrl,
                              startDate: _startDateInput.text,
                              startTime: _startTimeInput.text,
                              endDate: _endDateInput.text,
                              endTime: _endTimeInput.text,
                              place: _place.text,
                              type: _eventType.text,
                              status:
                                  ticketList.length == 0 || ticketList.isEmpty
                                      ? 'draft'
                                      : 'active',
                              ticket: ticketList);
                        }
                        setState(() => _isLoading = false);
                        Navigator.pushNamed(context, MainMenu.route);
                      } on CloudinaryException catch (e) {
                        print(e.message);
                        print(e.request);
                      }
                    }
                  }),
            );
          },
        ),
      ),
    );
  }
}
