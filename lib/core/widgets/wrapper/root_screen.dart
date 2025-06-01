import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/widgets/wrapper/main_wrapper.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/content_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/search_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/home_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/search/search_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/add_post_screen.dart';
import 'package:offgrid_nation_app/features/chat/presentation/screens/messages_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/premium_screen.dart';
import 'package:offgrid_nation_app/injection_container.dart';

/// RootScreen manages the bottom navigation's state and shows the appropriate page.
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  // Holds the current tab index.
  int _currentTabIndex = 0;

  final List<Widget> _screens = [
    BlocProvider<ContentBloc>(
      // ✅ Provide ContentBloc ONLY to FeedScreen
      create: (_) => sl<ContentBloc>(),
      child: const FeedScreen(),
    ),
    BlocProvider<SearchUserBloc>(
      // ✅ Provide SearchUserBloc ONLY to SearchScreen
      create: (_) => sl<SearchUserBloc>(),
      child: const SearchScreen(),
    ),
    const AddPostScreen(),
    BlocProvider<ChatBloc>(
      create: (_) => sl<ChatBloc>(),
      child: const MessagesScreen(),
    ),

    const PremiumScreen(),
  ];

  // Updates the current tab index when a navigation icon is tapped.
  void _onTabSelected(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainWrapper(
      currentTabIndex: _currentTabIndex,
      onTabSelected: _onTabSelected,
      child: IndexedStack(index: _currentTabIndex, children: _screens),
    );
  }
}
