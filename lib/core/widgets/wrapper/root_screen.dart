import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/widgets/wrapper/main_wrapper.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/events/chat_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/content_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/search_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/home_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/search/search_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/add_post_screen.dart';
import 'package:offgrid_nation_app/features/chat/presentation/screens/messages_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/premium/premium_screen.dart';
import 'package:offgrid_nation_app/injection_container.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentTabIndex = 0;

  late final List<bool> _isTabBuilt = List.filled(5, false);

  @override
  void initState() {
    super.initState();
    _isTabBuilt[0] = true; // First tab should build initially
  }

  void _onTabSelected(int index) {
    if (_currentTabIndex == index && index == 3) {
      // If Chat tab tapped again → force refresh
      sl<ChatBloc>().add(const GetConversationsRequested());
    } else {
      setState(() {
        _currentTabIndex = index;
        _isTabBuilt[index] = true; // Mark tab as visited → allow building
      });
    }
  }

  Widget _buildTabScreen(int index) {
    switch (index) {
      case 0:
        return MultiBlocProvider(
          providers: [
            BlocProvider<ContentBloc>(create: (_) => sl<ContentBloc>()),
            BlocProvider<ChatBloc>(create: (_) => sl<ChatBloc>()),
          ],
          child: const FeedScreen(),
        );

      case 1:
        return BlocProvider<SearchUserBloc>(
          create: (_) => sl<SearchUserBloc>(),
          child: const SearchScreen(),
        );
      case 2:
        return const AddPostScreen();
      case 3:
        return BlocProvider<ChatBloc>(
          create: (_) => sl<ChatBloc>(),
          child: const MessagesScreen(),
        );
      case 4:
        return const PremiumScreen();
      default:
        return const SizedBox.shrink(); // Always safe fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainWrapper(
      currentTabIndex: _currentTabIndex,
      onTabSelected: _onTabSelected,
      child: Stack(
        children: List.generate(5, (index) {
          return Offstage(
            offstage: _currentTabIndex != index,
            child: TickerMode(
              enabled: _currentTabIndex == index,
              child:
                  _isTabBuilt[index]
                      ? _buildTabScreen(index)
                      : const SizedBox.shrink(),
            ),
          );
        }),
      ),
    );
  }
}
