import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:seeq_business/components/buttons.dart';
import 'package:seeq_business/services/auth_service.dart';

import '../models/user.dart';
import '../services/main_db.dart';
import '../utils/constants.dart';
import 'onBoarding_page.dart';
import 'profile_setup.dart';

class ProfilePage extends StatelessWidget {
  static const route = '/setting';
  Authentication _auth = Authentication();
  Map<String, dynamic>? data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: Text('Profile', style: TextStyle(color: kWhiteColor)),
          centerTitle: true,
          elevation: 1),
      body: FutureBuilder(
          future: Hive.openBox('user'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final _userBox = Hive.box('user');
              final _user = _userBox.get('loggedInUser');

              if (snapshot.hasError) {
                return Container(
                    child: Center(child: Text('Error loading profile data')));
              }
              return SafeArea(
                child: CustomScrollView(
                  slivers: [
                    ValueListenableBuilder(
                        valueListenable: Hive.box('user').listenable(),
                        builder: (context, Box user, widget) {
                          return ProfileOverview(
                              user: user.get('loggedInUser'));
                        }),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      ScopedModelDescendant<AppModel>(
                          builder: (context, child, model) {
                        return ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Edit profile'),
                          subtitle:
                              Text('View and edit your profile accordingly'),
                          onTap: () async {
                            final profileData = await Navigator.pushNamed(
                                context, ProfileSetup.route,
                                arguments: _user);
                            if (profileData != null) {
                              print('the data $profileData');
                            }
                          },
                        );
                      }),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.support,
                        ),
                        title: Text('Support'),
                        subtitle: Text(
                            'Need help? Contact the support staff to help you'),
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
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    TextButton(
                                        child: Text('CANCEL',
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        onPressed: () =>
                                            Navigator.pop(context)),
                                    TextButton(
                                      child: Text('LOG OUT',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () => _auth.logout().then(
                                          (_) =>
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  OnBoardingPage.route,
                                                  (router) => false)),
                                    ),
                                  ],
                                );
                              });
                        },
                      )
                    ]))
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class ProfileOverview extends StatelessWidget {
  const ProfileOverview({
    Key? key,
    required UserProfile user,
  })  : _user = user,
        super(key: key);

  final UserProfile _user;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 200,
      forceElevated: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        background: Stack(
          fit: StackFit.expand,
          children: [
            _user.coverPic != ''
                ? CachedNetworkImage(
                    imageUrl: '${_user.coverPic}',
                    fit: BoxFit.fitWidth,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                : Image.asset(
                    'images/cover.png',
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _user.profilePicture != null
                            ? Align(
                                alignment: Alignment.bottomLeft,
                                child: CachedNetworkImage(
                                  imageUrl: "${_user.profilePicture}",
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 40,
                                    backgroundColor: kSecondaryColor,
                                    backgroundImage: imageProvider,
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                          radius: 40, child: Icon(Icons.error)),
                                ),
                              )
                            : CircleAvatar(
                                radius: 40,
                                backgroundColor: kGreyColor,
                                child: Icon(
                                  Icons.domain_outlined,
                                  size: 30,
                                  color: kBlackColor,
                                ),
                              ),
                      ),
                      Expanded(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${_user.name}\n',
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
                                    .copyWith(color: kWhiteColor, fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 38.0),
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
    );
  }
}
