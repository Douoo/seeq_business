import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF222831);
// const Color kSecondaryColor = Color(0xFF393E46);
const Color kSecondaryColor = Color(0xFFFF5722);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kGreyColor = Color(0xFFEEEEEE);
const Color kBlackColor = Color(0xFF000000);
const Color kTextFormFieldBorderColor = Colors.grey;
const Color kFocusedTextFormFieldBorderColor = Color(0xFF878787);

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
