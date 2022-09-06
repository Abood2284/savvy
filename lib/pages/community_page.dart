import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:web_chat_app/helpers.dart';
import 'package:web_chat_app/models/models.dart';
import 'package:web_chat_app/screens/chat_screen.dart';
import 'package:web_chat_app/widgets/avatar.dart';

import '../theme.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// * Flutter behind the scenes uses CustomScrollView to scroll the content. like: ListView, Column, Row
    /// Again CustomScrollView uses Slivers to scroll the screen
    /// You can use Slivers when you want to have complex scrolling, such as Column having listView & Row & column etc
    /// Slivers needs a list of Widgets
    /// Slivers asks for List<Widgets> which are slivers to convert your widget to slivers wrap them with SliverToBoxAdapter
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: _NameWelcomeCard(name: 'name'),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            _delegate,
            childCount: 20,
          ),
        ),
      ],
    );
  }

  Widget _delegate(BuildContext context, int index) {
    // final com = communities;
    var faker = Faker();
    return _communityTile(
      communityData: CommunityData(
        id: '1',
        name: faker.person.name(),
        profilePicture: Helpers.randomPictureUrl(),
        latestMessage: 'Helo',
      ),
    );
  }
}

class _communityTile extends StatelessWidget {
  const _communityTile({
    Key? key,
    required this.communityData,
  }) : super(key: key);

  final CommunityData communityData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ChatScreen.routeName, arguments: communityData);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 70,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 12, bottom: 15, top: 8),
              child: Avatar.medium(
                url: communityData.profilePicture,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      communityData.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        overflow: TextOverflow.ellipsis,
                        letterSpacing: 0.5,
                        wordSpacing: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Text(
                      communityData.latestMessage ?? '',
                      maxLines: 2,
                      style: const TextStyle(
                        color: AppColors.textFaded,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 12, top: 4),
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '1',
                    style: TextStyle(color: AppColors.textLigth, fontSize: 10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NameWelcomeCard extends StatelessWidget {
  const _NameWelcomeCard({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 12, bottom: 16, left: 18, right: 18),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 10, left: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi $name',
              style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  letterSpacing: 0.5,
                  wordSpacing: 1.5),
            ),
            const Text('Subtitle'),
          ],
        ),
      ),
    );
  }
}
