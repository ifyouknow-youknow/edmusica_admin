import 'package:edmusica_admin/PAGES/TEACHERS/edit_teacher.dart';
import 'package:edmusica_admin/PAGES/TEACHERS/new_teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library/COMPONENTS/button_view.dart';
import 'package:flutter_library/COMPONENTS/future_view.dart';
import 'package:flutter_library/COMPONENTS/iconbutton_view.dart';
import 'package:flutter_library/COMPONENTS/padding_view.dart';
import 'package:flutter_library/COMPONENTS/pill_view.dart';
import 'package:flutter_library/COMPONENTS/roundedcorners_view.dart';
import 'package:flutter_library/COMPONENTS/text_view.dart';
import 'package:flutter_library/FUNCTIONS/colors.dart';
import 'package:flutter_library/FUNCTIONS/nav.dart';
import 'package:flutter_library/MODELS/DATAMASTER/datamaster.dart';
import 'package:flutter_library/MODELS/firebase.dart';

class Teachers extends StatefulWidget {
  final DataMaster dm;
  const Teachers({super.key, required this.dm});

  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  Future<List<dynamic>> _fetchTeachers() async {
    final docs = await firebase_GetAllDocumentsOrderedQueried(
        '${widget.dm.theAppName}_Teachers',
        [
          {
            'field': 'districtId',
            'operator': '==',
            'value': widget.dm.user['districtId']
          }
        ],
        'firstName',
        'asc');
    return docs;
  }

  //
  @override
  Widget build(BuildContext context) {
    return RoundedCornersView(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            PaddingView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButtonView(
                      icon: Icons.add,
                      onPress: () {
                        nav_Push(context, NewTeacher(dm: widget.dm), () {
                          setState(() {});
                        });
                      })
                ],
              ),
            ),
            PaddingView(
              child: FutureView(
                  future: _fetchTeachers(),
                  childBuilder: (teachers) {
                    return Column(
                      children: [
                        for (var teacher in teachers)
                          Column(
                            children: [
                              ButtonView(
                                  child: PillView(
                                    backgroundColor: hexToColor('#F2F3F5'),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextView(
                                          text:
                                              '${teacher['firstName']} ${teacher['lastName']}',
                                          size: 18,
                                          font: 'poppins',
                                          wrap: true,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward,
                                          size: 24,
                                        )
                                      ],
                                    ),
                                  ),
                                  onPress: () {
                                    nav_Push(
                                        context,
                                        EditTeacher(
                                          dm: widget.dm,
                                          teacher: teacher,
                                        ), () {
                                      setState(() {});
                                    });
                                  }),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          )
                      ],
                    );
                  },
                  emptyWidget: const Center(
                    child: TextView(
                      text: 'No teachers yet.',
                    ),
                  )),
            )
          ],
        ));
  }
}
