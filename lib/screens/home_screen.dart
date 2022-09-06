// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:web_chat_app/helpers.dart';

import 'package:web_chat_app/widgets/widgets.dart';

import '../logger.dart';
import '../pages/community_page.dart';
import '../pages/notification_page.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  final log = getLogger('HomeScreen');
  late UserCredential currentUserUID;

  HomeScreen({
    Key? key,
  }) : super(key: key);

  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final ValueNotifier<String> titleIndex = ValueNotifier('Community');

  final pages = [
    const CommunityPage(),
    // ProfilePage(),
    const NotificationPage(),
  ];

  final title = const [
    'Community',
    // 'Profile',
    'Notification',
  ];

  void _NavigationItemSelected(index) {
    titleIndex.value = title[index];
    pageIndex.value = index;
  }

  void getDataFromFirestore(BuildContext context) {
    currentUserUID =
        ModalRoute.of(context)!.settings.arguments as UserCredential;
    log.i(currentUserUID.user!.uid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUID.user!.uid)
        .get()
        .then((value) {
      Map<String, dynamic> currentUserData =
          value.data() as Map<String, dynamic>;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getDataFromFirestore(context));
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: titleIndex,
          builder: (BuildContext context, String value, Widget? child) =>
              Text(titleIndex.value),
        ),
        leading: Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            splashColor: AppColors.secondary,
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              // getDataFromFirestore(context);
              log.i("TODO SEARCH");
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                IconlyLight.search,
                size: 22,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 21.0),
            child: Avatar.small(url: Helpers.randomPictureUrl()),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: ((BuildContext context, int value, _) {
          return pages[value];
        }),
      ),
      bottomNavigationBar: _BottomNavigationBar(
        onItemSelected: _NavigationItemSelected,
      ),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  final ValueChanged<int> onItemSelected;

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  final log = getLogger('_BottomNavigationBar');
  int selectedItemIndex = 0;

  void selectedItemOnTap(int index) {
    setState(() {
      selectedItemIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(0),
      color: (brightness == Brightness.light) ? AppColors.cardLight : null,
      elevation: 0,
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationBarItem(
                index: 0,
                icon: IconlyBold.chat,
                onTap: selectedItemOnTap,
                isSelected: selectedItemIndex == 0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: GlowingActionButton(
                  color: AppColors.secondary,
                  icon: CupertinoIcons.add,
                  onPressed: () {
                    log.w("TODO ADD Button");
                  },
                ),
              ),
              // _NavigationBarItem(
              //   index: 1,
              //   icon: IconlyBold.profile,
              //   onTap: selectedItemOnTap,
              //   isSelected: selectedItemIndex == 1,
              // ),
              _NavigationBarItem(
                index: 1,
                icon: Icons.notifications,
                onTap: selectedItemOnTap,
                isSelected: selectedItemIndex == 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem({
    Key? key,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
    required this.index,
  }) : super(key: key);

  final IconData icon;
  final int index;
  final ValueChanged<int> onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        width: 70,
        height: 50,
        child: Icon(
          icon,
          size: 34,
          color: isSelected ? AppColors.secondary : null,
        ),
      ),
    );
  }
}
