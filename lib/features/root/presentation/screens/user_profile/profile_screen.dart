import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/widgets/custom_loader.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/user_profile_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/profile/profile/profile_tabs_cupertino.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/profile/profile/profile_tabs_material.dart';

class MyProfileScreen extends StatefulWidget {
  final String? username;
  const MyProfileScreen({super.key, this.username});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with SingleTickerProviderStateMixin {
  int _cupertinoTabIndex = 0;
  late final TabController _tabController;
  int _lastTabIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<UserProfileBloc>();
      widget.username != null
          ? bloc.add(FetchUserProfileById(widget.username!))
          : bloc.add(const FetchProfileRequested(limit: 10));
    });
  }

  bool _hasFetchedFollowing = false;
  bool _hasFetchedFollowers = false;

  void _onTabChanged() {
    if (_tabController.index != _lastTabIndex) {
      _lastTabIndex = _tabController.index;
      final username =
          widget.username ??
          context.read<UserProfileBloc>().state.profileData?['username'];
      if (username == null || username.isEmpty) return;

      if (_tabController.index == 0 && !_hasFetchedFollowing) {
        _hasFetchedFollowing = true;
        context.read<UserProfileBloc>().add(FetchFollowingRequest(username));
      } else if (_tabController.index == 2 && !_hasFetchedFollowers) {
        _hasFetchedFollowers = true;
        context.read<UserProfileBloc>().add(FetchFollowersRequest(username));
      }
    }
  }

  void _onCupertinoTabChange(int index) {
    setState(() => _cupertinoTabIndex = index);
    final state = context.read<UserProfileBloc>().state;
    final username = widget.username ?? state.profileData?['username'];
    if (username == null || username.isEmpty) return;

    if (index == 0) {
      context.read<UserProfileBloc>().add(FetchFollowingRequest(username));
    } else if (index == 2) {
      context.read<UserProfileBloc>().add(FetchFollowersRequest(username));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? _buildCupertinoView() : _buildMaterialView();
  }

  Widget _buildCupertinoView() {
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

            return ProfileTabsCupertino(
              data: data,
              tabIndex: _cupertinoTabIndex,
              onTabChange: _onCupertinoTabChange,
              isEditable: widget.username == null,
            );
          },
        ),
      ),
    );
  }

  Widget _buildMaterialView() {
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

            return ProfileTabsMaterial(
              data: data,
              tabController: _tabController,
              isEditable: widget.username == null,
            );
          },
        ),
      ),
    );
  }
}
