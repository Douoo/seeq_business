import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';
import 'package:seeq_business/utils/constants.dart';

import '../components/buttons.dart';
import '../utils/size_config.dart';
import 'main_menu.dart';

class VerifySMS extends StatefulWidget {
  static const String route = '/verification';
  @override
  _VerifySMSState createState() => _VerifySMSState();

  @override
  String toStringShort() => 'Rounded With Cursor';
}

class _VerifySMSState extends State<VerifySMS> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Verify Your Phone',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.03,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                  children: [
                    TextSpan(
                      text: "Insert the code sent to the number\n",
                    ),
                    TextSpan(
                      text: '+2519121234567',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.04,
              ),
              Pinput(
                controller: pinController,
                focusNode: focusNode,
                // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
                defaultPinTheme: defaultPinTheme,
                validator: (value) {
                  return value == '2222' ? null : 'Pin is incorrect';
                },
                onClipboardFound: (value) {
                  debugPrint('onClipboardFound: $value');
                  pinController.setText(value);
                },
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: debugPrint,
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 9),
                      width: 22,
                      height: 1,
                      color: focusedBorderColor,
                    ),
                  ],
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                  children: [
                    TextSpan(
                      text: "Didn't recieve the code? ",
                    ),
                    const TextSpan(
                      text: 'Resend',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: kPrimaryColor,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RoundButton(
          onTap: () {
            Navigator.pushNamed(context, MainMenu.route);
            //TODO: SMS verification
          },
          title: 'Verify',
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
