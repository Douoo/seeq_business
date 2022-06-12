import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:seeq_business/models/user.dart';

import 'package:seeq_business/services/auth_service.dart';

import 'screens/events/add_ticket.dart';
import 'screens/events/ticket_setup.dart';
import 'screens/profile_settings.dart';
import 'services/main_db.dart';
import 'screens/events.dart';
import 'screens/events/event_setup.dart';
import 'screens/main_menu.dart';
import 'screens/onBoarding_page.dart';
import 'screens/login.dart';
import 'screens/profile_setup.dart';
import 'screens/sign_up_pages/organizers_name.dart';
import 'screens/sign_up_pages/set_profile.dart';
import 'screens/sms_verification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(UserProfileAdapter(), override: true);
  // await Hive.openBox('loggedInUser');
  runApp(SeeqBusiness());
}

class SeeqBusiness extends StatelessWidget {
  SeeqBusiness({Key? key}) : super(key: key);

  final AppModel _dataModel = AppModel();
  final Authentication _authModel = Authentication();

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _authModel,
      child: ScopedModel(
        model: _dataModel,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Seeq Partner',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: _authModel.isAuthenticated()
              ? MainMenu.route
              : OnBoardingPage.route, //OnBoardingPage.route,
          routes: {
            OnBoardingPage.route: (context) => OnBoardingPage(),
            Login.route: (context) => Login(),
            MainMenu.route: (context) => MainMenu(model: _dataModel),
            VerifySMS.route: (context) => VerifySMS(),
            Events.route: (context) => Events(model: _dataModel),
            AddTicket.route: (context) => AddTicket(),
            TicketSetup.route: (context) => TicketSetup(),
            EventSetup.route: (context) => EventSetup(),
            ProfilePage.route: (context) => ProfilePage(),
            ProfileSetup.route: (context) => ProfileSetup(),
            EventOrganizerName.route: (context) => EventOrganizerName(),
            SetProfile.route: (context) => SetProfile()
          },
        ),
      ),
    );
  }
}
