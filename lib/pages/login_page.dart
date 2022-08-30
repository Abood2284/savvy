import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import '../logger.dart';
import '../screens/screens.dart';
import '../theme.dart';
import '../widgets/widgets.dart';

// ! It is stateful just because we need the dispose method to dispose the controller.
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final log = getLogger('LoginPage');
  final Auth _auth = Auth();
  final formGlobalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onLoginButtonPressed(String email, String pass) async {
    _isLoading.value = true;
    if (formGlobalKey.currentState!.validate()) {
      formGlobalKey.currentState!.save();
      // log.i('Emai!l: $email, Pass: $pass');
      UserCredential currentUser = await _auth
          .signInWithEmailAndPassword(email: email, password: pass)
          .whenComplete(() => _isLoading.value = false);
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName, (route) => false,
          arguments: currentUser);
    }
  }

  // Used to validate the password field.
  bool isPasswordValid(String password) => password.length >= 6;
  // Used to validate the email field.
  bool isEmailValid(String email) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    String email = '';
    String pass = '';

    return SizedBox(
      height: 200,
      child: Form(
        key: formGlobalKey,
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 28,
                  color: AppTheme.accentColor,
                ),
              ),
              const Text(
                'Sign In to continue!',
                style: TextStyle(
                  color: AppColors.textFaded,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              TextFieldBuilder(
                validator: (email) {
                  if (!isEmailValid(email!)) {
                    return 'Invalid email';
                  }
                  return null;
                },
                labelText: 'Email',
                controller: _emailController,
                icon: Icons.mail_outline,
                onChanged: (value) {
                  email = value;
                  log.d(email);
                },
              ),
              const SizedBox(
                height: 22,
              ),
              TextFieldBuilder(
                validator: (password) {
                  if (!isPasswordValid(password!)) {
                    return 'Please Enter atlease 6 digit pass';
                  }
                  return null;
                },
                labelText: 'Password',
                controller: _passController,
                icon: Icons.lock,
                onChanged: (value) {
                  pass = value;
                  log.d(pass);
                },
              ),
              const SizedBox(height: 22),
              ValueListenableBuilder(
                valueListenable: _isLoading,
                builder:
                    (BuildContext context, bool isLoadingTrue, Widget? child) {
                  return isLoadingTrue
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              _onLoginButtonPressed(email, pass);
                            },
                            child: const Text('Login'),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
