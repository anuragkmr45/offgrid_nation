import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/widgets/custom_loader.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/user_profile_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
// import '../../widget/profile/user_profile_header.dart';
// import '../../widget/profile/user_followers_tab.dart';
// import '../../widget/profile/user_posts_tab.dart';
// import '../../widget/profile/user_following_tab.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  int _cupertinoTabIndex = 0;
  late TabController _tabController;
  String? _username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (_username == null && args is String && args.isNotEmpty) {
      _username = args;

      context.read<UserProfileBloc>().add(FetchUserProfileById(_username!));
      context.read<UserProfileBloc>().add(
        FetchPostsByUsername(_username!),
      ); // ✅ fetch posts
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  int _lastTabIndex = -1;

  void _handleTabChange() {
    if (!_tabController.indexIsChanging &&
        _lastTabIndex != _tabController.index) {
      _lastTabIndex = _tabController.index;
      final username = _username;
      switch (_tabController.index) {
        case 0:
          context.read<UserProfileBloc>().add(FetchFollowingRequest(username!));
          break;
        case 2:
          context.read<UserProfileBloc>().add(FetchFollowersRequest(username!));
          break;
      }
    }
  }

  void _onCupertinoTabChange(int index) {
    setState(() => _cupertinoTabIndex = index);
    final username = _username;
    switch (index) {
      case 0:
        context.read<UserProfileBloc>().add(FetchFollowingRequest(username!));
        break;
      case 2:
        context.read<UserProfileBloc>().add(FetchFollowersRequest(username!));
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
        middle: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            final name =
                (state.profileData?['fullName'] ?? '').toString().trim();
            final username =
                (state.profileData?['username'] ?? '').toString().trim();
            final title = name.isNotEmpty ? name : '@$username';

            return Text(
              title,
              style: const TextStyle(color: AppColors.background),
            );
          },
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

            if (state.status == UserProfileStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Error loading profile'),
              );
            }

            final data = state.profileData;
            if (data == null) return const SizedBox.shrink();

            final followers = data['followersCount']?.toString() ?? '0';
            final following = data['followingCount']?.toString() ?? '0';
            final posts = data['postsCount']?.toString() ?? '0';

            return Column(
              // children: [
              //   ProfileHeader(userData: data),
              //   const SizedBox(height: 10),
              //   CupertinoSegmentedControl<int>(
              //     groupValue: _cupertinoTabIndex,
              //     children: {
              //       0: Text('Following $following'),
              //       1: Text('Posts $posts'),
              //       2: Text('Followers $followers'),
              //     },
              //     onValueChanged: _onCupertinoTabChange,
              //   ),
              //   const SizedBox(height: 10),
              //   Expanded(
              //     child: _getCupertinoTabContent(), // ✅ dynamic tab content
              //   ),
              // ],
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
        title: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            final name =
                (state.profileData?['fullName'] ?? '').toString().trim();
            final username =
                (state.profileData?['username'] ?? '').toString().trim();
            final title = name.isNotEmpty ? name : '@$username';
            return Text(
              title,
              style: const TextStyle(color: AppColors.background),
            );
          },
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

            if (state.status == UserProfileStatus.failure) {
              return Center(child: Text(state.errorMessage ?? 'Error'));
            }

            final data = state.profileData;
            if (data == null) return const SizedBox.shrink();

            final followers = data['followersCount']?.toString() ?? '0';
            final following = data['followingCount']?.toString() ?? '0';
            final posts = data['postsCount']?.toString() ?? '0';

            return Column(
              children: [
                // ProfileHeader(userData: data),
                TabBar(
                  controller: _tabController, // ✅ use the same controller
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
                    controller:
                        _tabController, // ✅ FIX: controller added here too
                    children: const [
                      // FollowingTab(),
                      // PostsTab(),
                      // FollowersTab(),
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

  Widget _getCupertinoTabContent() {
    switch (_cupertinoTabIndex) {
      // case 0:
      //   return const FollowingTab();
      // case 1:
      //   return const PostsTab();
      // case 2:
      //   return const FollowersTab();
      default:
        return const SizedBox.shrink();
    }
  }
}
