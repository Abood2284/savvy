import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:web_chat_app/pages/login_page.dart';
import 'package:web_chat_app/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'theme.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final client = StreamChatClient(dotenv.env['STREAM_KEY']!);
  await dotenv.load(fileName: ".env");

  runApp(MyApp(
    appTheme: AppTheme(),
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appTheme, required this.client});

  final AppTheme appTheme;
  final StreamChatClient client;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme.light,
      darkTheme: appTheme.dark,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return StreamChatCore(
          client: client,
          child: child!,
        );
      },
      home: LoginPage(),
      onGenerateRoute: (settings) => genrateRoute(settings),
    );
  }
}
