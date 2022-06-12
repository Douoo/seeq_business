import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeq_business/screens/sign_up_pages/set_profile.dart';

import '../../components/buttons.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class EventOrganizerName extends StatefulWidget {
  static const String route = '/fill_in_oragnizers_name';
  @override
  _EventOrganizerNameState createState() => _EventOrganizerNameState();
}

class _EventOrganizerNameState extends State<EventOrganizerName> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _organizerName;
  final FocusNode _focusOnNameField = FocusNode();
  // final FocusNode _focusOnSubmitField = FocusNode();
  //bool sameUserName = false;
  bool _hasUserName = false;
  bool _isLoading = false;
  String? inputText;
  RegExp characterValidator = RegExp("");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      color: kSecondaryColor,
                      height: 10,
                      width: SizeConfig.screenWidth / 3,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 1),
                      Text(
                        "Enter your event organizer's name",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontWeight: FontWeight.bold, color: kBlackColor),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.05),
                      Column(
                        children: [
                          Column(
                            children: [
                              TextFormField(
                                textCapitalization: TextCapitalization.words,
                                focusNode: _focusOnNameField,
                                textInputAction: TextInputAction.next,
                                onChanged: (text) {
                                  setState(() {
                                    _organizerName = text.trim();
                                    _hasUserName = true;
                                  });
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length == 0) {
                                    return "Name is required";
                                  } else if (value.length < 3) {
                                    return "Name must be at least 3 characters";
                                  } else if (isInvalid(value)) {
                                    return "Invalid name, try inserting an appropirate name";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Organizer name eg. JORKA',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal),
                                  focusColor: Colors.orange,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryColor,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  errorStyle: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      Text(
                        'This information will be used when you withdraw money from your account. You will not be able to change it.',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: RoundButton(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                final _auth = FirebaseAuth.instance;

                _auth.currentUser!.updateDisplayName('$_organizerName');
                Navigator.pushNamed(context, SetProfile.route,
                    arguments: OrganizerName(_organizerName!));
              }
            },
            color: kPrimaryColor,
            textColor: kWhiteColor,
            title: 'CONTINUE'),
      ),
    );
  }

  Future exitDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text('Are you sure?',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
            ),
            content: Text(
                'You will exit this sign-up process and all your information will be deleted.',
                textAlign: TextAlign.center),
            actions: [
              TextButton(
                child: Text(
                  'NO',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                  child: Text(
                    'YES',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {})
            ],
          );
        });
  }
}
