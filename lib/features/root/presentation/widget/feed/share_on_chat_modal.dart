// import 'dart:async' show Timer;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';
// import 'package:offgrid_nation_app/features/root/presentation/bloc/content_bloc.dart';
// import 'package:offgrid_nation_app/features/root/presentation/widget/feed/user_search_card.dart';

// class Debouncer {
//   final int milliseconds;
//   Timer? _timer;

//   Debouncer({required this.milliseconds});

//   void run(VoidCallback action) {
//     _timer?.cancel();
//     _timer = Timer(Duration(milliseconds: milliseconds), action);
//   }
// }

// class ShareOnChatModal extends StatefulWidget {
//   const ShareOnChatModal({super.key});

//   @override
//   State<ShareOnChatModal> createState() => _ShareOnChatModalState();
// }

// class _ShareOnChatModalState extends State<ShareOnChatModal> {
//   final TextEditingController _searchController = TextEditingController();
//   bool hasTyped = false;
//   final Debouncer _debouncer = Debouncer(milliseconds: 400);

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged(String value) {
//     _debouncer.run(() {
//       final query = value.trim();
//       setState(() => hasTyped = query.isNotEmpty);
//       context.read<ContentBloc>().add(SearchUsersRequested(query));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 350,
//       child: Column(
//         children: [
//           CustomSearchBar(
//             controller: _searchController,
//             hintText: 'Search users...',
//             onChanged: _onSearchChanged,
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: BlocBuilder<ContentBloc, ContentState>(
//               builder: (context, state) {
//                 if (!hasTyped || state.searchResults == null) {
//                   return const Center(
//                     child: Text(
//                       'Start typing to search users...',
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   );
//                 }

//                 if (state.searchResults!.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'No users found.',
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   itemCount: state.searchResults!.length,
//                   itemBuilder: (_, index) {
//                     final user = state.searchResults![index];
//                     return UserSearchCard(
//                       user: user,
//                       onTap: () {
//                         // handle chat start or share logic
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/utils/debouncer.dart';
import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/content_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/feed/user_search_card.dart';

class ShareOnChatModal extends StatefulWidget {
  final String postId;

  const ShareOnChatModal({
    super.key,
    required this.postId,
  });

  @override
  State<ShareOnChatModal> createState() => _ShareOnChatModalState();
}

class _ShareOnChatModalState extends State<ShareOnChatModal> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 400);
  final ValueNotifier<bool> _isSharing = ValueNotifier(false);
  bool hasTyped = false;

  @override
  void dispose() {
    _searchController.dispose();
    _isSharing.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      final query = value.trim();
      setState(() => hasTyped = query.isNotEmpty);
      context.read<ContentBloc>().add(SearchUsersRequested(query));
    });
  }

  void _showToast(String message) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(12),
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  Future<void> _sharePost(String recipientId) async {
    if (_isSharing.value) return;

    _isSharing.value = true;
    try {
      context.read<ContentBloc>().add(
            SharePostRequested(
              context: context,
              postId: widget.postId,
              recipientId: recipientId,
            ),
          );

      Navigator.of(context).pop();
      _showToast("Post shared successfully!");
    } catch (e) {
      _showToast("Failed to share post");
    } finally {
      _isSharing.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          CustomSearchBar(
            controller: _searchController,
            hintText: 'Search users...',
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _isSharing,
            builder: (_, isSharing, __) {
              return Expanded(
                child: Stack(
                  children: [
                    BlocBuilder<ContentBloc, ContentState>(
                      builder: (context, state) {
                        if (!hasTyped || state.searchResults == null) {
                          return const Center(
                            child: Text(
                              'Start typing to search users...',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        if (state.searchResults!.isEmpty) {
                          return const Center(
                            child: Text(
                              'No users found.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: state.searchResults!.length,
                          itemBuilder: (_, index) {
                            final user = state.searchResults![index];
                            return UserSearchCard(
                              user: user,
                              onTap: () => _sharePost(user.id),
                            );
                          },
                        );
                      },
                    ),
                    if (isSharing)
                      const Positioned.fill(
                        child: ColoredBox(
                          color: Colors.black26,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
