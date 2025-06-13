import 'dart:async' show Timer;
// import 'dart:ui' show VoidCallback;
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/bloc/events/chat_event.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class ShareOnChatModal extends StatefulWidget {
  const ShareOnChatModal({super.key});

  @override
  State<ShareOnChatModal> createState() => _ShareOnChatModalState();
}

class _ShareOnChatModalState extends State<ShareOnChatModal> {
  final TextEditingController _searchController = TextEditingController();
  bool hasTyped = false;
  final Debouncer _debouncer = Debouncer(milliseconds: 400);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      final query = value.trim();
      setState(() => hasTyped = query.isNotEmpty);
      // if (query.isNotEmpty) {
      //   context.read<ChatBloc>().add(SearchUsersRequested(query));
      // }
    });
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
          const Expanded(
            child: Center(
              child: Text(
                'No search action implemented.\nJust search bar as requested.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:io' show Platform;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:offgrid_nation_app/core/utils/debouncer.dart';
// import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/bloc/events/chat_event.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/bloc/states/chat_state.dart';

// class ShareOnChatModal extends StatefulWidget {
//   final Function(Map<String, dynamic> user)? onUserSelected;

//   const ShareOnChatModal({super.key, this.onUserSelected});

//   @override
//   State<ShareOnChatModal> createState() => _ShareOnChatModalState();
// }

// class _ShareOnChatModalState extends State<ShareOnChatModal> {
//   final Debouncer _debouncer = Debouncer(milliseconds: 400);
//   final TextEditingController _searchController = TextEditingController();
//   bool _hasTyped = false;

//   @override
//   void initState() {
//     super.initState();
//     // Safe → clear search bar on open → no accidental API trigger
//     // _searchController.clear();
//     // _hasTyped = false;
//   }

//   void _onSearchChanged(String value) {
//     _debouncer.run(() {
//       final query = value.trim();
//       setState(() => _hasTyped = query.isNotEmpty);
//       if (query.isNotEmpty) {
//         context.read<ChatBloc>().add(SearchUsersRequested(query));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isIOS = Platform.isIOS;

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
//             child: BlocBuilder<ChatBloc, ChatState>(
//               builder: (context, state) {
//                 if (state is ChatLoading && _hasTyped) {
//                   return Center(
//                     child: isIOS
//                         ? const CupertinoActivityIndicator()
//                         : const CircularProgressIndicator(),
//                   );
//                 } else if (state is SearchResultsLoaded) {
//                   final users = state.users;
//                   if (users.isEmpty) {
//                     return const Center(child: Text('No users found'));
//                   }

//                   return ListView.separated(
//                     itemCount: users.length,
//                     separatorBuilder: (_, __) => const Divider(height: 1),
//                     itemBuilder: (_, i) {
//                       final user = users[i];
//                       return ListTile(
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 4,
//                           vertical: 4,
//                         ),
//                         leading: CircleAvatar(
//                           radius: 24,
//                           backgroundImage: NetworkImage(user.profilePicture),
//                         ),
//                         title: Text(
//                           '@${user.username}',
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Text(
//                           user.fullName,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         trailing: IconButton(
//                           icon: const Icon(Icons.message),
//                           onPressed: () => widget.onUserSelected?.call({
//                             '_id': user.id,
//                             'username': user.username,
//                             'fullName': user.fullName,
//                             'profilePicture': user.profilePicture,
//                           }),
//                         ),
//                       );
//                     },
//                   );
//                 } else if (state is ChatError) {
//                   return Center(child: Text(state.message));
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// 