// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String? profileUrl;
  // final String category; //! Don't have any usage for now.
  final List<String>? communityID; //! Communities Marked True are listed here

  UserModel({
    required this.uid,
    required this.name,
    this.profileUrl,
    // required this.category,
    this.communityID,
  });

  UserModel get user => UserModel(
        uid: uid,
        name: name,
        profileUrl: profileUrl ??
            'https://asset.cloudinary.com/dmd7ubap5/605805dd3c79ee121f49869d1445991d',
        // category: category,
        communityID: communityID,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profileUrl': profileUrl,
      'communityID': communityID,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profileUrl:
          map['profileUrl'] != null ? map['profileUrl'] as String : null,
      communityID: map['communityID'] != null
          ? map['communityID'] as List<String>
          : null,
    );
  }

//! Only if communityID field was List<CommunityData>
  // communityID: map['communityID'] != null
  //         ? (map['communityID'] as List<dynamic>)
  //             .map((e) => CommunityIDData.fromMap(e as Map<String, dynamic>))
  //             .toList()
  //         : null,

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
