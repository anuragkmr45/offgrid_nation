// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:offgrid_nation_app/features/root/domain/entities/premium/post_entity.dart';
// import 'package:offgrid_nation_app/core/utils/formate_post_time.dart';
// import 'package:offgrid_nation_app/core/widgets/media_carousel/media_carousel.dart';

// class PremiumPostWidget extends StatelessWidget {
//   final PostEntity post;
//   final VoidCallback onLikeTap;
//   final VoidCallback onCommentTap;
//   final VoidCallback onShareTap;
//   final VoidCallback onProfileTap;

//   const PremiumPostWidget({
//     super.key,
//     required this.post,
//     required this.onLikeTap,
//     required this.onCommentTap,
//     required this.onShareTap,
//     required this.onProfileTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color:Color(0xFFFbbc06),
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Header Row
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: onProfileTap,
//                   child: CircleAvatar(
//                     radius: 20,
//                     backgroundImage: CachedNetworkImageProvider(
//                       "https://res.cloudinary.com/dkwptotbs/image/upload/v1749901306/fr-bg-white_hea7pb.png",
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "OFFGRID NATION",
//                       style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//                     ),
//                     Text(
//                       formatPostTime(post.createdAt.toIso8601String()),
//                       style: const TextStyle(fontSize: 12, color: Colors.black87),
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// Media
//             if (post.media.isNotEmpty) MediaCarousel(mediaUrls: post.media),

//             const SizedBox(height: 8),

//             /// Description
//             // if (post.content.isNotEmpty)
//             //   Text(
//             //     post.content,
//             //     style: const TextStyle(fontSize: 14, color: Colors.black),
//             //   ),
//             const SizedBox(height: 10),

//             /// Actions
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: onLikeTap,
//                   icon: Icon(
//                     post.isLiked ? Icons.flash_on : Icons.flash_on_outlined,
//                     color: post.isLiked ? Colors.orange : Colors.grey,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: onCommentTap,
//                   icon: const Icon(Icons.comment_outlined),
//                 ),
//                 IconButton(
//                   onPressed: onShareTap,
//                   icon: const Icon(Icons.share_outlined),
//                 ),
//               ],
//             ),

//             Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Row(
//                 children: [
//                   Text(
//                     '${post.likesCount} likes',
//                     style: const TextStyle(fontSize: 13, color: Colors.black),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     '${post.commentsCount} comments',
//                     style: const TextStyle(fontSize: 13, color: Colors.black),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/premium/post_entity.dart';
import 'package:offgrid_nation_app/core/utils/formate_post_time.dart';
import 'package:offgrid_nation_app/core/widgets/media_carousel/media_carousel.dart';

class PremiumPostWidget extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onProfileTap;

  const PremiumPostWidget({
    super.key,
    required this.post,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFbbc06),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                GestureDetector(
                  onTap: onProfileTap,
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                      "https://res.cloudinary.com/dkwptotbs/image/upload/v1749901306/fr-bg-white_hea7pb.png",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "OFFGRID NATION",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      formatPostTime(post.createdAt.toIso8601String()),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Media
            if (post.media.isNotEmpty) MediaCarousel(mediaUrls: post.media),
            const SizedBox(height: 8),

            /// Description
            if (post.content.isNotEmpty)
              Text(
                post.content,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            const SizedBox(height: 10),

            /// Actions with Images
            Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: IconButton(
                    key: ValueKey<bool>(post.isLiked),
                    icon: Image.asset(
                      post.isLiked
                          ? 'lib/assets/images/post-like-icon.png'
                          : 'lib/assets/images/post-dislike-icon.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: onLikeTap,
                  ),
                ),
                IconButton(
                  icon: Image.asset(
                    'lib/assets/images/comment-icon.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: onCommentTap,
                ),
                IconButton(
                  icon: Image.asset(
                    'lib/assets/images/share-icon.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: onShareTap,
                ),
              ],
            ),

            /// Stats
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text(
                    '${post.likesCount} likes',
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${post.commentsCount} comments',
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
