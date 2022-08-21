import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:web_chat_app/helpers.dart';
import 'package:web_chat_app/models/community_model.dart';
import 'package:web_chat_app/widgets/widgets.dart';

import '../theme.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat-Screen';
  const ChatScreen({
    Key? key,
    required this.communityData,
  }) : super(key: key);

  final CommunityData communityData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.center,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            splashColor: AppColors.secondary,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  IconlyLight.arrow_left_2,
                ),
              ),
            ),
          ),
        ),
        title: _AppBarTitle(communityData: communityData),
      ),
      body: Center(
        child: Text(communityData.name),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    Key? key,
    required this.communityData,
  }) : super(key: key);

  final CommunityData communityData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar.small(
          url: Helpers.randomPictureUrl(),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              communityData.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              '234 Members',
              style: TextStyle(color: AppColors.textFaded, fontSize: 12),
            )
          ],
        )
      ],
    );
  }
}
