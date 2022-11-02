/*
! NO LONGER USED -> DEPRECATED BY @Abood2284 on 2 Nov 2022
! DELETEING PERMISSION GRANTED
! KEPT FOR CODE REFERENCE ONLY
*/

import 'package:flutter/material.dart';
import 'package:web_chat_app/pages/login_page.dart';
import 'package:web_chat_app/pages/signup_page.dart';

class AuthScreeen extends StatelessWidget {
  static const String routeName = '/auth';
  AuthScreeen({Key? key}) : super(key: key);

  final ValueNotifier<String> _authStatus = ValueNotifier('Login');

  final _authTypes = [
    'Login',
    'Signup',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(''),
      ),
      body: ValueListenableBuilder(
        valueListenable: _authStatus,
        builder: (BuildContext context, String value, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: _authStatus.value == 'Login'
                    ? LoginPage()
                    : const SignupPage(),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_authStatus.value == 'Login'
                          ? 'I\'m a new user.'
                          : 'I\'m already a member.'),
                      TextButton(
                        child: Text(_authStatus.value == 'Login'
                            ? 'Sign Up'
                            : 'Sign In'),
                        onPressed: () {
                          _authStatus.value =
                              _authTypes[_authStatus.value == 'Login' ? 1 : 0];
                        },
                      ),
                    ],
                  )
                  //  TextButton(
                  //   child: Text(_authStatus.value == 'Login'
                  //       ? 'Create Account'
                  //       : 'Already have an account?'),
                  //   onPressed: () {
                  //     _authStatus.value =
                  //         _authTypes[_authStatus.value == 'Login' ? 1 : 0];
                  //   },
                  // ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
