import 'package:flutter/material.dart';
import 'package:flutter_library/COMPONENTS/main_view.dart';
import 'package:flutter_library/MODELS/DATAMASTER/datamaster.dart';

class Dashboard extends StatefulWidget {
  final DataMaster dm;
  const Dashboard({super.key, required this.dm});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, mobile: [
      // TOP
    ]);
  }
}
