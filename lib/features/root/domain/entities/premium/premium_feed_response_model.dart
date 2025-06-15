import './post_entity.dart';

class PremiumFeedResponseModel {
  final bool isPremium;
  final List<PostEntity> posts;

  PremiumFeedResponseModel({required this.isPremium, required this.posts});

  factory PremiumFeedResponseModel.fromJson(Map<String, dynamic> json) {
    final isPremium = json.containsKey("posts");
    return PremiumFeedResponseModel(
      isPremium: isPremium,
      posts: isPremium
          ? List<PostEntity>.from(
              json['posts'].map((e) => PostEntity.fromJson(e)),
            )
          : [],
    );
  }
}
