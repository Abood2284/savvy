import 'package:flutter/material.dart';
import 'package:web_chat_app/screens/screens.dart';

import 'models/community_model.dart';

Route<dynamic> genrateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeScreen(),
      );
    case ChatScreen.routeName:
      var communityData = routeSettings.arguments as CommunityModel;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ChatScreen(communityData: communityData),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Error 404'),
          ),
        ),
      );
  }
}
