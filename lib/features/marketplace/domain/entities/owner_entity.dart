class OwnerEntity {
  final String userId;
  final String username;
  final String profilePicture;

  OwnerEntity({
    required this.userId,
    required this.username,
    required this.profilePicture,
  });

  factory OwnerEntity.fromJson(Map<String, dynamic> json) {
    return OwnerEntity(
      userId: json['userId'],
      username: json['username'],
      profilePicture: json['profilePicture'],
    );
  }
}
