import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

const Color kPrimaryColor = Color(0xFF222831);
const Color kLightDark = Color(0xFF393E46);
const Color kSecondaryColor = Color(0xFFFF5722);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kGreyColor = Color(0xFFEEEEEE);
const Color kBlackColor = Color(0xFF000000);
const Color kTextFormFieldBorderColor = Colors.grey;
const Color kFocusedTextFormFieldBorderColor = Color(0xFF878787);

List<IconData> categoryIcons = [
  Icons.music_note_outlined,
  Icons.badge_outlined,
  Icons.theaters_outlined,
  Icons.campaign_outlined,
  Icons.cast,
  Icons.room_service_outlined,
  Icons.emoji_events_outlined,
  Icons.business_center_outlined,
  Icons.article_outlined,
  Icons.sports_esports_outlined,
  Icons.cabin_outlined,
  Icons.festival_outlined,
  Icons.park_outlined,
  Icons.pedal_bike_outlined,
  Icons.airport_shuttle_outlined,
  Icons.lightbulb_outline,
];

List<String> eventCategories = [
  "Music",
  "Convention",
  "Tradeshow or Consumer show",
  "Seminar or Conference",
  "Screening",
  "Dinner or Gala",
  "Tournaments",
  "Meeting or Networking Event",
  "Classes, Training or Workshop",
  "Game or Competition",
  "Camping and Outdoor",
  "Festival",
  "Attraction",
  "Race or Endurance Event",
  "Tour and Travel",
  "Tour and Travel",
];

int dotIndicator = 0;
final List<Map<String, dynamic>> showCaseInfo = [
  {
    'image': 'images/analytics.png',
    'title': 'Check on your event stats',
    'description': 'Analyse the statistics of your event on the go',
    'color': Colors.blueGrey
  },
  {
    'image': 'images/revenue.png',
    'title': 'Track how your event is doing',
    'description': 'Easily track how your event is doing in sales.',
    'color': kSecondaryColor
  },
  {
    'image': 'images/app_logo.png',
    'title': '',
    'description': '',
    'color': kPrimaryColor
  },
];

const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
const fillColor = Color.fromRGBO(243, 246, 249, 0);
const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(
    fontSize: 22,
    color: kPrimaryColor,
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(19),
    border: Border.all(color: borderColor),
  ),
);

final RegExp phoneValidator = RegExp(r"^[0-9]");

const kSettingTitleTextStyle = TextStyle(
    fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Roboto-Regular');
const kButtonTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.w500,
  fontFamily: 'Roboto-Medium',
);

const InputDecoration kTextFieldDecoration = InputDecoration(
  labelText: 'Email',
  labelStyle: TextStyle(color: Colors.grey),
  focusColor: kPrimaryColor,
  hoverColor: kPrimaryColor,
  icon: Icon(
    Icons.email,
    color: Colors.grey,
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: kPrimaryColor,
      style: BorderStyle.solid,
    ),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: kTextFormFieldBorderColor,
    ),
  ),
  errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
    ),
  ),
  focusedErrorBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
    ),
  ),
);

const InputDecoration kDefaultTextFieldDecoration = InputDecoration(
  labelText: 'Enter data',
  labelStyle: TextStyle(color: Colors.grey),
  focusColor: kPrimaryColor,
  hoverColor: kPrimaryColor,
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: kPrimaryColor,
      style: BorderStyle.solid,
    ),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: kTextFormFieldBorderColor,
    ),
  ),
  errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
    ),
  ),
  focusedErrorBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
    ),
  ),
);

fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Add a comment',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: kPrimaryColor, width: 2.0),
  ),
);

bool isInvalid(String value) {
  return value.contains("+") ||
      value.contains("_") ||
      value.contains("₩") ||
      value.contains("¥") ||
      value.contains("£") ||
      value.contains("€") ||
      value.contains("÷") ||
      value.contains("×") ||
      value.contains("€") ||
      value.contains("-") ||
      value.contains("(") ||
      value.contains(")") ||
      value.contains("*") ||
      value.contains("&") ||
      value.contains("^") ||
      value.contains("%") ||
      value.contains(" ") ||
      value.contains("#") ||
      value.contains("@") ||
      value.contains("!") ||
      value.contains("}") ||
      value.contains("{") ||
      value.contains("[") ||
      value.contains("]") ||
      value.contains(":") ||
      value.contains(";") ||
      value.contains("'") ||
      value.contains("\"") ||
      value.contains("\ ") ||
      value.contains("|") ||
      value.contains("<") ||
      value.contains(",") ||
      value.contains(">") ||
      value.contains(".") ||
      value.contains("/") ||
      value.contains("?") ||
      value.contains("~") ||
      value.contains("`");
}
