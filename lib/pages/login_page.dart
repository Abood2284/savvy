import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:web_chat_app/helpers.dart';
import 'package:web_chat_app/widgets/twitter_sign_in_button.dart';

import '../auth.dart';
import '../logger.dart';
import '../screens/screens.dart';
import '../theme.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final log = getLogger('LoginPage');

  final Auth _auth = Auth();

  Future<void> onTwitterSignInButtonPressesd(BuildContext context) async {
    try {
      // log.i(dotenv.env['TWITTER_API_KEY']);
      // log.i(dotenv.env['TWITTER_API_SECRET_KEY']);
      final twitterLogin = TwitterLogin(
        apiKey: dotenv.env['TWITTER_API_KEY']!,
        apiSecretKey: dotenv.env['TWITTER_API_SECRET_KEY']!,
        redirectURI: "savvy://",
      );

      final authResult = await twitterLogin.login();

      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          final twitterAuthCredential = TwitterAuthProvider.credential(
              accessToken: authResult.authToken!,
              secret: authResult.authTokenSecret!);

          final userCredential =
              await _auth.signInWithCredential(twitterAuthCredential);
          log.d(userCredential.toString());
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routeName, (route) => false,
              arguments: userCredential);
          break;

        case TwitterLoginStatus.cancelledByUser:
          log.e(TwitterLoginStatus.cancelledByUser.toString());
          break;

        case TwitterLoginStatus.error:
          log.e(TwitterLoginStatus.error.toString());
          break;
        default:
          return;
      }
    } on FirebaseAuthException catch (e) {
      log.e(e.message);
      Helpers.ShowDialog(context, e.message ?? 'Unknown error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          const SizedBox(
            height: 50,
          ),
          TwitterSignInButton(
            faIcon: const FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
            text: 'Sign in with Twitter',
            onPressed: () {
              onTwitterSignInButtonPressesd(context);
            },
          ),
        ],
      ),
    );
  }
}
