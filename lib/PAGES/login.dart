import 'package:edmusica_admin/PAGES/dashboard.dart';
import 'package:edmusica_admin/PAGES/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_library/COMPONENTS/button_view.dart';
import 'package:flutter_library/COMPONENTS/image_view.dart';
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

class Login extends StatefulWidget {
  final DataMaster dm;
  const Login({super.key, required this.dm});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  //
  void onLogIn() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      setState(() {
        widget.dm.alertMissingInfo();
      });
      return;
    }

    setState(() {
      widget.dm.setToggleLoading(true);
    });

    final user = await auth_SignIn(_email.text, _password.text, 'Admin');
    if (user != null) {
      widget.dm.setToggleLoading(false);
      nav_PushAndRemove(context, Dashboard(dm: widget.dm));
    } else {
      setState(() {
        widget.dm.setToggleLoading(false);
        widget.dm.alertSomethingWrong();
      });
      return;
    }
  }

  void init() async {
    setState(() {
      widget.dm.setToggleLoading(true);
    });
    final signedIn = await widget.dm.checkUser('Admin');
    print('WE ARE ${signedIn ? 'true' : 'false'}');
    if (signedIn) {
      nav_PushAndRemove(context, Dashboard(dm: widget.dm));
    }
    setState(() {
      widget.dm.setToggleLoading(false);
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
      // TOP
      PaddingView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonView(
              child: const PillView(
                child: Row(
                  children: [
                    TextView(text: 'sign up', size: 16),
                    Icon(
                      Icons.arrow_forward,
                      size: 20,
                    ),
                  ],
                ),
              ),
              onPress: () {
                nav_Push(context, SignUp(dm: widget.dm));
              },
            ),
          ],
        ),
      ),
      //
      PaddingView(
        child: ImageView(
          imagePath: 'assets/edm-logo.png',
          height: getHeight(context) * 0.3,
          width: getWidth(context),
        ),
      ),
      const PaddingView(
          paddingLeft: 20,
          paddingRight: 20,
          child: TextView(
            text:
                'For all teachers and admin under the Escuela De Musica network.',
            wrap: true,
            size: 18,
          )),
      const Spacer(
        flex: 1,
      ),
      SingleChildScrollView(
        child: PaddingView(
          child: Column(
            children: [
              TextfieldView(
                controller: _email,
                placeholder: 'Email',
                backgroundColor: hexToColor('#F2F3F5'),
                radius: 100,
                keyboardType: TextInputType.emailAddress,
                paddingH: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              TextfieldView(
                paddingH: 20,
                controller: _password,
                placeholder: 'Password',
                backgroundColor: hexToColor('#F2F3F5'),
                radius: 100,
                isPassword: true,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonView(
                      child: const TextView(
                        text: 'forgot password?',
                        size: 16,
                        weight: FontWeight.w500,
                      ),
                      onPress: () async {
                        final success = await auth_ForgotPassword(_email.text);
                        if (success) {
                          setState(() {
                            widget.dm.setToggleAlert(true);
                            widget.dm.setAlertTitle('Email Sent');
                            widget.dm.setAlertText(
                                'Your reset password link was sent to your email.');
                          });
                        } else {
                          setState(() {
                            widget.dm.alertSomethingWrong();
                          });
                        }
                      }),
                  ButtonView(
                      child: PillView(
                        backgroundColor: hexToColor('#375AF6'),
                        child: const TextView(
                          text: 'log in',
                          size: 16,
                          color: Colors.white,
                          weight: FontWeight.w500,
                        ),
                      ),
                      onPress: () {
                        onLogIn();
                      })
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
