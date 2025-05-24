import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/utils/debouncer.dart';
import 'package:offgrid_nation_app/core/utils/user_actions.dart';
import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/search_user_model.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/search_bloc.dart';
import '../../widget/search/account_list_item.dart';
import '../../widget/search/topic_list_item.dart';
import '../../widget/search/search_screen_tabs.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();

    // Trigger initial empty search
    context.read<SearchUserBloc>().add(const FetchSearchUserRequested(''));

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (query.isEmpty) {
        context.read<SearchUserBloc>().add(const FetchSearchUserRequested(''));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      context.read<SearchUserBloc>().add(FetchSearchUserRequested(trimmed));
    }
  }

  void _onTabSelected(int index) {
    setState(() => _currentTabIndex = index);
  }

  Widget _buildTopicTab() {
    return ListView(
      children: const [
        TopicListItem(
          title: 'Flood',
          imageUrl: 'https://example.com/flood.jpg',
        ),
        TopicListItem(
          title: 'Wildfire',
          imageUrl: 'https://example.com/wildfire.jpg',
        ),
      ],
    );
  }

  Widget _buildAccountsTab(SearchUserState state) {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Search users by typing in the bar above',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    if (state.status == SearchUserStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final users = state.results ?? [];

    if (users.isEmpty) {
      return const Center(
        child: Text('No users found.', style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final user = users[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/user-profile',
              arguments: user.username,
            );
          },
          child: ProfileListItem(
            name: user.fullName.isNotEmpty ? user.fullName : user.username,
            handle: '@${user.username}',
            avatarUrl: user.profilePicture,
            isFollowing: user.isFollowing,
            isBlocked: user.isBlocked,
            onFollow: () async {
              final isNowFollowing = await UserActions.toggleFollow(
                context: context,
                username: user.username,
                isBlocked: user.isBlocked,
              );

              final updated = List<SearchUserModel>.from(users);
              updated[index] = user.copyWith(isFollowing: isNowFollowing);
              context.read<SearchUserBloc>().emit(
                state.copyWith(results: updated),
              );

              return isNowFollowing;
            },
          ),
        );
      },
    );

    // return ListView.separated(
    //   itemCount: users.length,
    //   separatorBuilder: (_, __) => const SizedBox(height: 8),
    //   itemBuilder: (context, index) {
    //     final user = users[index];
    //     return ProfileListItem(
    //       name: user.fullName.isNotEmpty ? user.fullName : user.username,
    //       handle: '@${user.username}',
    //       avatarUrl: user.profilePicture,
    //       isFollowing: user.isFollowing,
    //       isBlocked: user.isBlocked,
    //       onFollow: () async {
    //         final isNowFollowing = await UserActions.toggleFollow(
    //           context: context,
    //           username: user.username,
    //           isBlocked: user.isBlocked,
    //         );

    //         final updated = List<SearchUserModel>.from(users);
    //         updated[index] = user.copyWith(isFollowing: isNowFollowing);
    //         context.read<SearchUserBloc>().emit(
    //           state.copyWith(results: updated),
    //         );

    //         return isNowFollowing;
    //       },
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final content = Container(
      color: Colors.blue,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CustomSearchBar(
            controller: _searchController,
            onChanged: (value) => _debouncer.run(() => _triggerSearch(value)),
            onSubmitted: _triggerSearch,
            hintText: 'Search...',
          ),
          const SizedBox(height: 16),
          CustomTabBar(
            currentIndex: _currentTabIndex,
            onTabSelected: _onTabSelected,
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                _currentTabIndex == 0
                    ? BlocBuilder<SearchUserBloc, SearchUserState>(
                      builder: (context, state) => _buildAccountsTab(state),
                    )
                    : _buildTopicTab(),
          ),
        ],
      ),
    );

    return isIOS
        ? CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(middle: Text('Search')),
          child: SafeArea(child: content),
        )
        : Scaffold(body: content);
  }
}
