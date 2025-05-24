class SearchUserModel {
  final String id;
  final String username;
  final String fullName;
  final String profilePicture;
  final bool isFollowing;
  final bool isBlocked;

  SearchUserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profilePicture,
    required this.isFollowing,
    required this.isBlocked,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      isFollowing: json['isFollowing'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  SearchUserModel copyWith({bool? isFollowing}) {
    return SearchUserModel(
      username: username,
      fullName: fullName,
      profilePicture: profilePicture,
      isFollowing: isFollowing ?? this.isFollowing,
      isBlocked: isBlocked,
      id: id,
    );
  }
}
