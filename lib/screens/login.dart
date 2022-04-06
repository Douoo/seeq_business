import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

import '../components/buttons.dart';
import '../utils/constants.dart';
import '../utils/size_config.dart';
import 'main_menu.dart';
import 'sms_verification.dart';

class Login extends StatefulWidget {
  static const String route = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kBlackColor),
          backgroundColor: kWhiteColor,
          elevation: 0,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'Enter your phone number to continue\n\n',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const TextSpan(
                      text:
                          'By continuing, you confirm that you are authorized to use this phone number and agree to receive an SMS text. Carrier fees may apply.',
                    )
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              TextFormField(
                controller: phoneNumber,
                decoration: InputDecoration(
                  hintText: '912123467',
                  prefixIcon: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: 0.5,
                                color: Theme.of(context).accentColor))),
                    child: CountryCodePicker(
                      onChanged: print,
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: 'ET',
                      favorite: ['+251', 'FR'],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.03),
              RoundButton(
                onTap: () => Navigator.pushNamed(context, VerifySMS.route),
                title: 'CONTINUE',
              ),
            ],
          ),
        )));
  }
}
