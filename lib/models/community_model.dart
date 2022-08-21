import 'package:meta/meta.dart';

@immutable
class CommunityData {
  const CommunityData({
    required this.id,
    required this.name,
    required this.profilePicture,
    this.latestMessage,
  });

  final String id;
  final String name;
  final String profilePicture;
  final String? latestMessage;
}
