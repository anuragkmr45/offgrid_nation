import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/widgets/custom_loader.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/user_profile_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import '../../widget/profile/profile_header.dart';
import '../../widget/profile/followers_tab.dart';
import '../../widget/profile/posts_tab.dart';
import '../../widget/profile/following_tab.dart';

class MyProfileScreen extends StatefulWidget {
  final String? username;

  const MyProfileScreen({super.key, this.username});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with SingleTickerProviderStateMixin {
  int _cupertinoTabIndex = 0;
  late TabController _tabController;
  int _lastTabIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_handleTabChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.username != null) {
        context.read<UserProfileBloc>().add(
          FetchUserProfileById(widget.username!),
        );
      } else {
        context.read<UserProfileBloc>().add(const FetchProfileRequested());
      }
    });
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging &&
        _lastTabIndex != _tabController.index) {
      _lastTabIndex = _tabController.index;
      final state = context.read<UserProfileBloc>().state;
      final username = widget.username ?? state.profileData?['username'];
      if (username == null || username.isEmpty) return;

      switch (_tabController.index) {
        case 0:
          context.read<UserProfileBloc>().add(FetchFollowingRequest(username));
          break;
        case 2:
          context.read<UserProfileBloc>().add(FetchFollowersRequest(username));
          break;
      }
    }
  }

  void _onCupertinoTabChange(int index) {
    setState(() => _cupertinoTabIndex = index);

    final state = context.read<UserProfileBloc>().state;
    final username = widget.username ?? state.profileData?['username'];
    if (username == null || username.isEmpty) return;

    switch (index) {
      case 0:
        context.read<UserProfileBloc>().add(FetchFollowingRequest(username));
        break;
      case 2:
        context.read<UserProfileBloc>().add(FetchFollowersRequest(username));
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? _buildCupertinoPage() : _buildMaterialPage();
  }

  Widget _buildCupertinoPage() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.username != null ? 'User Profile' : 'My Profile',
          style: const TextStyle(color: AppColors.background),
        ),
        backgroundColor: AppColors.primary,
        border: null,
      ),
      child: SafeArea(
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state.status == UserProfileStatus.loading) {
              return const CustomLoader();
            }

            final data =
                widget.username == null
                    ? state.profileData
                    : state.userProfileData;

            if (state.status == UserProfileStatus.failure && data == null) {
              return Center(
                child: Text(state.errorMessage ?? 'Profile not found.'),
              );
            }

            final followers = data?['followersCount']?.toString() ?? '0';
            final following = data?['followingCount']?.toString() ?? '0';
            final posts = data?['postsCount']?.toString() ?? '0';

            return Column(
              children: [
                ProfileHeader(
                  userData: data!,
                  isEditable: widget.username == null,
                ),
                const SizedBox(height: 10),
                CupertinoSegmentedControl<int>(
                  groupValue: _cupertinoTabIndex,
                  children: {
                    0: Text('Following $following'),
                    1: Text('Posts $posts'),
                    2: Text('Followers $followers'),
                  },
                  onValueChanged: _onCupertinoTabChange,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: IndexedStack(
                    index: _cupertinoTabIndex,
                    children: const [
                      FollowingTab(),
                      PostsTab(),
                      FollowersTab(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMaterialPage() {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.username != null ? 'User Profile' : 'My Profile',
          style: const TextStyle(color: AppColors.background),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.background),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state.status == UserProfileStatus.loading) {
              return const CustomLoader();
            }

            final data =
                widget.username == null
                    ? state.profileData
                    : state.userProfileData;

            if (data == null) {
              return Center(
                child: Text(state.errorMessage ?? 'Profile not found.'),
              );
            }

            final followers = data['followersCount']?.toString() ?? '0';
            final following = data['followingCount']?.toString() ?? '0';
            final posts = data['postsCount']?.toString() ?? '0';

            return Column(
              children: [
                ProfileHeader(
                  userData: data,
                  isEditable: widget.username == null,
                ),
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.background,
                  labelColor: AppColors.background,
                  unselectedLabelColor: AppColors.background,
                  tabs: [
                    Tab(child: Text('Following $following')),
                    Tab(child: Text('Posts $posts')),
                    Tab(child: Text('Followers $followers')),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      FollowingTab(),
                      PostsTab(),
                      FollowersTab(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
