import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:seeq_business/screens/main_menu.dart';

import '../../components/buttons.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class SetProfile extends StatefulWidget {
  static const String route = '/set_profile';
  // final String name;

  // const SetProfile({Key? key, required this.name}) : super(key: key);
  @override
  _SetProfileState createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  bool _isLoading = false;
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrganizerName;
    final String name = args.name;
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        body: ListView(
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  color: kSecondaryColor,
                  height: 10,
                  width: SizeConfig.screenWidth / 1.5,
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 1),
                  Text(
                    "Almost done...",
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.bold, color: kBlackColor),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  Column(
                    children: [
                      Column(
                        children: [
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _descriptionController,
                            // focusNode: _focusOnNameField,
                            textInputAction: TextInputAction.next,
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.trim().length == 0) {
                                return "Description is required";
                              } else if (value.length < 6) {
                                return "Your description must be at least 3 characters";
                              } else if (value.length > 200) {
                                return "Your description must be at less than 200 characters";
                              } else if (isInvalid(value)) {
                                return "Invalid name, try inserting an appropirate name";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText:
                                  'Describe what kind of event you organize.',
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
                    'State what describes your profile well accurate. You can edit this at a later time',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: RoundButton(
            onTap: () async {
              setState(() => _isLoading = true);
              final _auth = FirebaseAuth.instance;
              final authService = Authentication();
              // DatabaseReference userData =
              //     FirebaseDatabase.instance.ref().child("event_organizers");

              Map<String, dynamic> userData = {
                "_id": _auth.currentUser!.uid,
                "displayName": _auth.currentUser!.displayName,
                "phoneNumber": _auth.currentUser!.phoneNumber,
                "about": _descriptionController.text
              };
              final bool registrationSuccessful =
                  await authService.registerUser(userData);
              if (registrationSuccessful) {
                setState(() => _isLoading = false);

                Navigator.pushNamedAndRemoveUntil(
                    context, MainMenu.route, (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                        'Check your internet connection and try again!')));
              }
              // userData.child(_auth.currentUser!.uid).update(data);
            },
            color: kPrimaryColor,
            textColor: kWhiteColor,
            title: 'COMPLETE PROFILE'),
      ),
    );
  }
}

class OrganizerName {
  final String name;

  OrganizerName(this.name);
}
