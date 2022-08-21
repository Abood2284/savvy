import 'package:flutter/material.dart';
import 'package:web_chat_app/widgets/text_field.dart';

import '../logger.dart';
import '../theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final log = getLogger('LoginPage');
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();

    String email = '';
    String pass = '';

    return SizedBox(
      height: 200,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Sign In to continue!',
              style: TextStyle(
                color: AppColors.textFaded,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 16),
            TextFieldBuilder(
              labelText: 'Email',
              controller: emailController,
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
              labelText: 'Password',
              controller: passController,
              icon: Icons.lock,
              onChanged: (value) {
                pass = value;
                log.d(pass);
              },
            ),
          ],
        ),
      ),
    );
  }
}