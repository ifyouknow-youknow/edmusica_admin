import 'dart:io';

import 'package:edmusica_admin/PAGES/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library/COMPONENTS/button_view.dart';
import 'package:flutter_library/COMPONENTS/main_view.dart';
import 'package:flutter_library/COMPONENTS/padding_view.dart';
import 'package:flutter_library/COMPONENTS/pill_view.dart';
import 'package:flutter_library/COMPONENTS/text_view.dart';
import 'package:flutter_library/COMPONENTS/textfield_view.dart';
import 'package:flutter_library/FUNCTIONS/colors.dart';
import 'package:flutter_library/FUNCTIONS/nav.dart';
import 'package:flutter_library/MODELS/DATAMASTER/datamaster.dart';
import 'package:flutter_library/MODELS/constants.dart';
import 'package:flutter_library/MODELS/firebase.dart';
import 'package:flutter_library/MODELS/screen.dart';

class SignUp extends StatefulWidget {
  final DataMaster dm;
  const SignUp({super.key, required this.dm});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _districtCode = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConf = TextEditingController();

  void onSignUp() async {
    //
    setState(() {
      if (_firstName.text.isEmpty ||
          _lastName.text.isEmpty ||
          _email.text.isEmpty ||
          _districtCode.text.isEmpty ||
          _password.text.isEmpty ||
          _passwordConf.text.isEmpty) {
        setState(() {
          widget.dm.alertMissingInfo();
        });
        return;
      }

      if (_password.text != _passwordConf.text) {
        setState(() {
          widget.dm.setToggleAlert(true);
          widget.dm.setAlertTitle('Passwords Must Match');
          widget.dm.setAlertText('Your passwords must match to continue.');
        });
        return;
      }
//
      widget.dm.setToggleAlert(true);
      widget.dm.setAlertTitle('Create New Account');
      widget.dm.setAlertText(
          'Are you sure you want to create a new admin account with this info?');
      widget.dm.setAlertButtons([
        ButtonView(
            child: PillView(
              backgroundColor: hexToColor('#375AF6'),
              child: const TextView(
                text: 'Proceed',
                color: Colors.white,
                size: 16,
                weight: FontWeight.w600,
              ),
            ),
            onPress: () async {
              //
              setState(() {
                widget.dm.setToggleAlert(false);
                widget.dm.setToggleLoading(true);
              });

              // CHECK DISTRICT
              final docs = await firebase_GetAllDocumentsQueried(
                  '${appName}_Districts', [
                {'field': 'code', 'operator': '==', 'value': _districtCode.text}
              ]);
              if (docs.isNotEmpty) {
                // CONTINUE HERE

                final args = {
                  'firstName': _firstName.text,
                  'lastName': _lastName.text,
                  'email': _email.text,
                  'districtId': docs[0]['id'],
                };
                final user = await auth_CreateUser(_email.text, _password.text);
                if (user != null) {
                  final success = await firebase_CreateDocument(
                      '${appName}_Admin', user.uid, args);
                  if (success) {
                    widget.dm.setToggleLoading(false);
                    nav_PushAndRemove(
                        context,
                        Dashboard(
                          dm: widget.dm,
                        ));
                  }
                } else {
                  setState(() {
                    widget.dm.setToggleLoading(false);
                    widget.dm.alertSomethingWrong();
                  });
                }
              } else {
                setState(() {
                  widget.dm.setToggleLoading(false);
                  widget.dm.setToggleAlert(true);
                  widget.dm.setAlertButtons([]);
                  widget.dm.setAlertTitle('Invalid District Code');
                  widget.dm
                      .setAlertText('Please provide a valid district code.');
                });
              }
            })
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, mobile: [
      PaddingView(
        child: Row(
          children: [
            ButtonView(
                child: const PillView(
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 20,
                      ),
                      TextView(
                        text: 'back',
                        size: 16,
                      ),
                    ],
                  ),
                ),
                onPress: () {
                  nav_Pop(context);
                })
          ],
        ),
      ),
      //
      const PaddingView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            text: 'Sign Up',
            size: 32,
            weight: FontWeight.w600,
            spacing: -1,
          ),
          SizedBox(
            height: 5,
          ),
          TextView(
            text:
                'Use this form to create a new administrator account. Please enter the district code provided to complete the setup.',
            wrap: true,
          )
        ],
      )),
      //
      Expanded(
          child: SingleChildScrollView(
        child: PaddingView(
          paddingLeft: 15,
          paddingRight: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextView(
                text: 'First Name',
              ),
              TextfieldView(
                controller: _firstName,
                placeholder: 'ex. John',
                backgroundColor: hexToColor('#F2F3F5'),
                radius: 100,
                paddingH: 15,
              ),
              const SizedBox(
                height: 10,
              ),
              const TextView(
                text: 'Last Name',
              ),
              TextfieldView(
                controller: _lastName,
                placeholder: 'ex. Doe',
                backgroundColor: hexToColor('#F2F3F5'),
                radius: 100,
                paddingH: 15,
              ),
              const SizedBox(
                height: 10,
              ),
              const TextView(
                text: 'Email',
              ),
              TextfieldView(
                controller: _email,
                placeholder: 'ex. jdoe@gmail.com',
                backgroundColor: hexToColor('#F2F3F5'),
                radius: 100,
                paddingH: 15,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              const TextView(
                text: 'District Code',
              ),
              const TextView(
                text: 'This code should be provided to you by Ed Musica Inc.',
                wrap: true,
                size: 12,
                color: Colors.black54,
              ),
              TextfieldView(
                controller: _districtCode,
                placeholder: 'ex. 12345678',
                backgroundColor: hexToColor('#F2F3F5'),
                radius: 100,
                paddingH: 15,
              ),
              const SizedBox(
                height: 10,
              ),
              const TextView(
                text: 'Password',
              ),
              TextfieldView(
                controller: _password,
                placeholder: '8 characters min',
                backgroundColor: hexToColor('#F2F3F5'),
                radius: 100,
                paddingH: 15,
                isPassword: true,
              ),
              const SizedBox(
                height: 10,
              ),
              const TextView(
                text: 'Confirm Password',
              ),
              TextfieldView(
                controller: _passwordConf,
                placeholder: 'Passwords must match',
                backgroundColor: hexToColor('#F2F3F5'),
                radius: 100,
                paddingH: 15,
                isPassword: true,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonView(
                      child: PillView(
                        backgroundColor: hexToColor('#375AF6'),
                        child: const TextView(
                          text: 'sign up',
                          size: 16,
                          weight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      onPress: () {
                        onSignUp();
                      })
                ],
              )
            ],
          ),
        ),
      ))
    ]);
  }
}
