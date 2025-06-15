import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/utils/debouncer.dart';
import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/events/chat_event.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/states/chat_state.dart';

class SearchUserBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic> user) onUserSelected;

  const SearchUserBottomSheet({super.key, required this.onUserSelected});

  @override
  State<SearchUserBottomSheet> createState() => _SearchUserBottomSheetState();
}

class _SearchUserBottomSheetState extends State<SearchUserBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 400);
  bool _hasTyped = false;

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      final query = value.trim();
      setState(() => _hasTyped = query.isNotEmpty);
      if (query.isNotEmpty) {
        context.read<ChatBloc>().add(SearchUsersRequested(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            CustomSearchBar(
              controller: _controller,
              hintText: 'Search users...',
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading && _hasTyped) {
                    return Center(
                      child:
                          isIOS
                              ? const CupertinoActivityIndicator()
                              : const CircularProgressIndicator(),
                    );
                  } else if (state is SearchResultsLoaded) {
                    final users = state.users;
                    if (users.isEmpty) {
                      return const Center(child: Text('No users found'));
                    }

                    return ListView.separated(
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final user = users[i];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: CachedNetworkImageProvider(user.profilePicture),
                          ),
                          title: Text(
                            '@${user.username}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            user.fullName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.message),
                            onPressed:
                                () => widget.onUserSelected({
                                  '_id': user.id,
                                  'username': user.username,
                                  'fullName': user.fullName,
                                  'profilePicture': user.profilePicture,
                                }),
                          ),
                          // onTap:
                          //     () => widget.onUserSelected({
                          //       '_id': user.id,
                          //       'username': user.username,
                          //       'fullName': user.fullName,
                          //       'profilePicture': user.profilePicture,
                          //     }),
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
