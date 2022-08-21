import 'package:web_chat_app/models/models.dart';

class UserModel {
  final String uid;
  final String name;
  final String profileUrl;
  final String category;
  final List<CommunityData> community;

  UserModel({
    required this.uid,
    required this.name,
    required this.profileUrl,
    required this.category,
    required this.community,
  });

  UserModel get user => UserModel(
        uid: uid,
        name: name,
        profileUrl: profileUrl,
        category: category,
        community: community,
      );
}
