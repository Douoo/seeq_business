import 'package:flutter/material.dart';

import '../components/buttons.dart';
import '../utils/constants.dart';

class ProfileSetup extends StatefulWidget {
  static const String route = '/profile_setup';
  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Update profile', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 1),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 215,
              forceElevated: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image.asset(
                    //   'images/background_image.jpg',
                    //   height: 200,
                    //   fit: BoxFit.cover,
                    // ),
                    Container(
                        color: Colors.grey,
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: kWhiteColor,
                            size: 50,
                          ),
                        )),
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x00000000),
                            Color(0xAA000000),
                          ],
                        ),
                      ),
                      // child: Align(
                      //   alignment: Alignment.bottomLeft,
                      //   // child: Padding(
                      //   //   padding: const EdgeInsets.all(8.0),
                      //   //   child:
                      //   // ),
                      // ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        TextFormField(
                          onFieldSubmitted: (submitted) {
                            // FocusScope.of(context).requestFocus();
                          },
                          decoration: kTextFieldDecoration.copyWith(
                              labelText: 'Organizers name',
                              icon: Icon(Icons.domain_outlined)),
                        ),
                        TextFormField(
                          onFieldSubmitted: (submitted) {
                            // FocusScope.of(context).requestFocus();
                          },
                          decoration: kTextFieldDecoration.copyWith(
                              labelText: 'Phone number',
                              icon: Icon(Icons.phone_outlined)),
                        ),
                        TextFormField(
                          onFieldSubmitted: (submitted) {
                            // FocusScope.of(context).requestFocus();
                          },
                          maxLines: 5,
                          decoration: kTextFieldDecoration.copyWith(
                              labelText: "Organizer's description",
                              icon: Icon(Icons.text_snippet_outlined)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: RoundButton(
                      onTap: () {
                        //TODO: Update user profile
                      },
                      title: 'UPDATE PROFILE',
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
