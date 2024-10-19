import 'package:flutter/material.dart';
import 'package:flutter_library/COMPONENTS/button_view.dart';
import 'package:flutter_library/COMPONENTS/iconbutton_view.dart';
import 'package:flutter_library/COMPONENTS/main_view.dart';
import 'package:flutter_library/COMPONENTS/padding_view.dart';
import 'package:flutter_library/COMPONENTS/pill_view.dart';
import 'package:flutter_library/COMPONENTS/text_view.dart';
import 'package:flutter_library/COMPONENTS/textfield_view.dart';
import 'package:flutter_library/FUNCTIONS/colors.dart';
import 'package:flutter_library/FUNCTIONS/nav.dart';
import 'package:flutter_library/MODELS/DATAMASTER/datamaster.dart';
import 'package:flutter_library/MODELS/firebase.dart';
import 'package:flutter_library/MODELS/screen.dart';

class NewTeacher extends StatefulWidget {
  final DataMaster dm;
  const NewTeacher({super.key, required this.dm});

  @override
  State<NewTeacher> createState() => _NewTeacherState();
}

class _NewTeacherState extends State<NewTeacher> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  //
  void onCreateTeacher() async {
    if (_firstName.text.isEmpty ||
        _lastName.text.isEmpty ||
        _email.text.isEmpty) {
      setState(() {
        widget.dm.alertMissingInfo();
      });
      return;
    }

    setState(() {
      widget.dm.setToggleLoading(true);
    });

    final user = await auth_CreateUser(_email.text, 'edmusica');
    if (user != null) {
      final success = await firebase_CreateDocument(
          '${widget.dm.theAppName}_Teachers', user.uid, {
        'firstName': _firstName.text,
        'lastName': _lastName.text,
        'email': _email.text,
        'districtId': widget.dm.user['districtId']
      });
      if (success) {
        setState(() {
          widget.dm.setToggleLoading(false);
        });
        nav_Pop(context);
      } else {
        setState(() {
          widget.dm.setToggleLoading(false);
          widget.dm.alertSomethingWrong();
        });
      }
    } else {
      setState(() {
        widget.dm.setToggleLoading(false);
        widget.dm.alertSomethingWrong();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, mobile: [
      PaddingView(
        child: Row(
          children: [
            IconButtonView(
                icon: Icons.chevron_left,
                onPress: () {
                  nav_Pop(context);
                })
          ],
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          child: PaddingView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextView(
                  text:
                      'Fill out the form below to create a new teacher account for your district.',
                  wrap: true,
                  size: 20,
                  weight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 15,
                ),
                const TextView(
                  text: 'first name',
                ),
                TextfieldView(
                  controller: _firstName,
                  placeholder: 'ex. john',
                  backgroundColor: hexToColor('#F2F3F5'),
                  radius: 100,
                ),
                const SizedBox(
                  height: 15,
                ),
                const TextView(
                  text: 'last name',
                ),
                TextfieldView(
                  controller: _lastName,
                  placeholder: 'ex. doe',
                  backgroundColor: hexToColor('#F2F3F5'),
                  radius: 100,
                ),
                const SizedBox(
                  height: 15,
                ),
                const TextView(
                  text: 'email',
                ),
                TextfieldView(
                  controller: _email,
                  placeholder: 'ex. jdoe@edmusica.com',
                  backgroundColor: hexToColor('#F2F3F5'),
                  radius: 100,
                ),
              ],
            ),
          ),
        ),
      ),
      //
      PaddingView(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ButtonView(
              child: PillView(
                  backgroundColor: hexToColor('#375AF6'),
                  child: const TextView(
                    text: 'create',
                    size: 16,
                    color: Colors.white,
                  )),
              onPress: () {
                onCreateTeacher();
              })
        ],
      ))
    ]);
  }
}
