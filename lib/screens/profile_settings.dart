import 'package:flutter/material.dart';
import 'package:seeq_business/components/buttons.dart';

import '../utils/constants.dart';
import '../utils/size_config.dart';
import 'profile_setup.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Profile', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 1),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                Container(
                  color: kBlackColor,
                  child: TextButton.icon(
                      icon: Icon(Icons.edit),
                      label: Text('EDIT'),
                      onPressed: () {},
                      style: TextButton.styleFrom(primary: kWhiteColor)),
                ),
              ],
              automaticallyImplyLeading: false,
              expandedHeight: 200,
              forceElevated: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'images/background_image.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
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
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: kSecondaryColor,
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'JORKA\n',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                              color: kWhiteColor,
                                            ),
                                      ),
                                      TextSpan(
                                        text: '0 Followers, 0 Events',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                color: kWhiteColor,
                                                fontSize: 10),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: RoundButton(
                                    onTap: () {},
                                    title: 'FOLLOWERS',
                                    color: kSecondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Edit profile'),
                subtitle: Text('View and edit your profile accordingly'),
                onTap: () {
                  //TODO: Edit/Setup account
                  Navigator.pushNamed(context, ProfileSetup.route);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.support,
                ),
                title: Text('Support'),
                subtitle:
                    Text('Need help? Contact the support staff to help you'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                subtitle: Text('Sign out of your account.'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Are you sure?',
                              textAlign: TextAlign.center),
                          content: Text('This will logout your account',
                              textAlign: TextAlign.center),
                          actions: [
                            TextButton(
                                child: Text('CANCEL',
                                    style: TextStyle(color: Colors.grey)),
                                onPressed: () => Navigator.pop(context)),
                            TextButton(
                                child: Text('LOG OUT',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () => Navigator.pop(context)),
                          ],
                        );
                      });
                },
              )
            ]))
          ],
        ),
      ),
    );
  }
}
