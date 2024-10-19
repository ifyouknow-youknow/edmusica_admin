import 'package:edmusica_admin/PAGES/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_library/MODELS/DATAMASTER/datamaster.dart';
import 'package:flutter_library/firebase_options.dart';

void main() async {
  final dm = DataMaster();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "lib/.env");
  dm.setTheAppName('Edmusica');
  runApp(MyApp(
    dm: dm,
  ));
}

class MyApp extends StatelessWidget {
  final DataMaster dm;
  const MyApp({super.key, required this.dm});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(
        dm: dm,
      ),
    );
  }
}
