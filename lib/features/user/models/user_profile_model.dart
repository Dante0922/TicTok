class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final bool hasAvatar;
  final String introduction;
  final String homepage;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.hasAvatar,
    required this.introduction,
    required this.homepage,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "",
        hasAvatar = false,
        introduction = "",
        homepage = "";

  //firebase에 Json으로 전달하기 위해 변환
  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
      "introduction": introduction,
      "homepage": homepage
    };
  }

  // 함수를 만드는 문법인듯? fromJson함수 신설
  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"],
        hasAvatar = json["hasAvatar"] ?? false,
        introduction = json["introduction"],
        homepage = json["homepage"];

  // 기존 데이터에 일부를 수정하기 위한 패턴
  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? link,
    bool? hasAvatar,
    String? introduction,
    String? homepage,
  }) {
    return UserProfileModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        name: name ?? this.name,
        bio: bio ?? this.bio,
        link: link ?? this.link,
        hasAvatar: hasAvatar ?? this.hasAvatar,
        introduction: introduction ?? this.introduction,
        homepage: homepage ?? this.homepage);
  }
}
