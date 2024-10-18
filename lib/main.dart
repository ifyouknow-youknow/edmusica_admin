import 'package:edmusica_admin/PAGES/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library/MODELS/DATAMASTER/datamaster.dart';

void main() {
  final dm = DataMaster();
  dm.getStarted();
  runApp(MyApp(dm: dm,));
}

class MyApp extends StatelessWidget {
  final DataMaster dm;
  const MyApp({super.key, required this.dm});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(dm: dm,),
    );
  }
}
