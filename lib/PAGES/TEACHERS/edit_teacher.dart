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

class EditTeacher extends StatefulWidget {
  final DataMaster dm;
  final Map<String, dynamic> teacher;
  const EditTeacher({super.key, required this.dm, required this.teacher});

  @override
  State<EditTeacher> createState() => _EditTeacherState();
}

class _EditTeacherState extends State<EditTeacher> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();

  void onSaveChanges() async {
    //
    if (_firstName.text.isEmpty || _lastName.text.isEmpty) {
      setState(() {
        widget.dm.alertMissingInfo();
      });
      return;
    }

    setState(() {
      widget.dm.setToggleLoading(true);
    });

    final success = await firebase_UpdateDocument(
        '${widget.dm.theAppName}_Teachers', widget.teacher['id'], {
      'firstName': _firstName.text,
      'lastName': _lastName.text,
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
  }

  void init() {
    setState(() {
      _firstName.text = widget.teacher['firstName'];
      _lastName.text = widget.teacher['lastName'];
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, mobile: [
      PaddingView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButtonView(
              icon: Icons.chevron_left,
              onPress: () {
                nav_Pop(context);
              },
            ),
          ],
        ),
      ),
      Expanded(
          child: SingleChildScrollView(
        child: PaddingView(
            paddingTop: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextView(
                  text: 'Make any necessary changes to the teacher account.',
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
              ],
            )),
      )),
      //
      PaddingView(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ButtonView(
              child: PillView(
                  backgroundColor: hexToColor('#375AF6'),
                  child: const TextView(
                    text: 'save',
                    color: Colors.white,
                    size: 16,
                  )),
              onPress: () {
                onSaveChanges();
              })
        ],
      ))
    ]);
  }
}
