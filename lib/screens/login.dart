import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pinput/pinput.dart';

import '../components/buttons.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../utils/size_config.dart';
import 'main_menu.dart';
import 'sign_up_pages/organizers_name.dart';
import 'sms_verification.dart';

class Login extends StatefulWidget {
  static const String route = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _phoneNumber;
  final _smsCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  late String verificationId;

  bool _isLoading = false;
  bool _isCodeSent = false;

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
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kBlackColor),
            backgroundColor: kWhiteColor,
            elevation: 0,
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  !_isCodeSent
                      ? Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.grey),
                                children: [
                                  TextSpan(
                                    text:
                                        'Enter your phone number to continue\n\n',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                                  const TextSpan(
                                    text:
                                        'By continuing, you confirm that you are authorized to use this phone number and agree to receive an SMS text. Carrier fees may apply.',
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.screenHeight * 0.02),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              'Verify Your Phone',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
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
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                                children: [
                                  TextSpan(
                                    text:
                                        "Insert the code sent to the number\n",
                                  ),
                                  TextSpan(
                                    text: '$_phoneNumber',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
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
                          ],
                        ),
                  !_isCodeSent
                      ? TextFormField(
                          keyboardType: TextInputType.phone,
                          onChanged: (String value) {
                            print('The value $value');
                            _phoneNumber = '+251$value';
                          },
                          validator: (value) {
                            _phoneNumber = value;
                            if (value == null || value.trim().length == 0) {
                              return 'Field is empty, please insert your phone number';
                            } else if (!phoneValidator.hasMatch(value)) {
                              return 'Invalid phone number, try entering a valid number';
                            } else if (value.length < 9 || value.length > 9) {
                              return 'Invalid phone number, try entering a valid number';
                            } else {
                              return null;
                            }
                          },
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary))),
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
                        )
                      : Pinput(
                          controller: pinController,
                          focusNode: focusNode,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsRetrieverApi,
                          defaultPinTheme: defaultPinTheme,
                          length: 6,
                          onChanged: (String value) {
                            _phoneNumber = '+251$value';
                          },
                          validator: (value) {
                            if (value == null || value.trim().length == 0) {
                              return 'You need to confirm your phone number';
                            } else if (value.length != 6) {
                              return 'Invalid code. Try inserting the correct code';
                            } else {
                              return null;
                            }
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
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  _isCodeSent
                      ? Column(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
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
                            SizedBox(height: SizeConfig.screenHeight * 0.04),
                          ],
                        )
                      : SizedBox(height: SizeConfig.screenHeight * 0.04),
                  RoundButton(
                    onTap: _isCodeSent
                        ? () async {
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: pinController.text.trim());

                            // await _auth.signInWithCredential(credential);
                            try {
                              await signInUser(credential);
                            } on FirebaseAuthException catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text('${e.message}'),
                                      actions: [
                                        TextButton(
                                            child: Text('OK'),
                                            onPressed: () =>
                                                Navigator.of(context).pop())
                                      ],
                                    );
                                  });
                            }
                          }
                        : () async {
                            await verifyPhone(_phoneNumber);
                          },
                    title: !_isCodeSent ? 'CONTINUE' : 'CONFIRM',
                  ),
                ],
              ),
            ),
          ))),
    );
  }

  verifyPhone(phoneNumber) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final PhoneVerificationCompleted verified =
          (PhoneAuthCredential credential) async {
        signInUser(credential);
      };
      final PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException authException) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('${authException.code}'),
                actions: [
                  TextButton(
                      child: Text(
                        'OK',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      };
      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verID) {
        print('Auto retrieval failed');
      };
      _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: (String verificationId, [int? resendToken]) async {
          setState(() {
            this.verificationId = verificationId;
            _isLoading = false;
            _isCodeSent = true;
          });
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    }
  }

  signInUser(PhoneAuthCredential credential) async {
    UserCredential result;
    User? user;

    try {
      result = await _auth.signInWithCredential(credential);
      user = result.user;
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'invalid-verification-code') {
        print("wrong verification code");
      }
    }
    if (user != null) {
      print('successfully signed in');
      Authentication auth = Authentication();
      bool isUserRegistered = await auth.isUserRegistered();

      if (isUserRegistered) {
        Navigator.pushNamedAndRemoveUntil(
            context, MainMenu.route, (route) => false).then((_) {
          setState(() {
            _isCodeSent = false;
          });
        });
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          EventOrganizerName.route,
          (route) => false,
        ).then((_) => setState(() => _isCodeSent = false));
      }
    } else {
      print('eeee...sth is wrong');
      // _auth.signOut();
      // return showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       content: Text('Something went wrong.Try again!'),
      //       actions: [
      //         TextButton(
      //           child: Text('OK'),
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //         )
      //       ],
      //     );
      //   },
      // );
    }
  }
}
