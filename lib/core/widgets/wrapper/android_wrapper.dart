import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class AndroidWrapper extends StatefulWidget {
  final Widget child;
  final int currentTabIndex;
  final ValueChanged<int>? onTabSelected;
  final bool isHomeScreen;
  final bool isPremium;

  const AndroidWrapper({
    super.key,
    required this.child,
    this.currentTabIndex = 0,
    this.onTabSelected,
    this.isHomeScreen = false,
    this.isPremium = false,
  });

  @override
  _AndroidWrapperState createState() => _AndroidWrapperState();
}

class _AndroidWrapperState extends State<AndroidWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // drawer: _buildDrawer(context),
      appBar: _buildHomeAppBar(context),
      // widget.isHomeScreen
      //     ? _buildHomeAppBar(context)
      //     : _buildOtherAppBar(context),
      body: Stack(
        children: [
          Positioned.fill(child: widget.child),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildCustomBottomNav(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBottomNav(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavIcon(iconData: Icons.home_outlined, index: 0),
            _buildNavIcon(iconData: Icons.search_outlined, index: 1),
            _buildNavIcon(iconData: Icons.add_circle_outline, index: 2),
            _buildNavIcon(iconData: Icons.chat_bubble_outline, index: 3),
            _buildNavIcon(iconData: Icons.workspace_premium_outlined, index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon({required IconData iconData, required int index}) {
    final bool isActive = widget.currentTabIndex == index;
    return GestureDetector(
      onTap: () {
        if (widget.onTabSelected != null) {
          widget.onTabSelected!(index);
        }
      },
      child: Icon(
        iconData,
        color: isActive ? AppColors.background : AppColors.textSecondary,
      ),
    );
  }

  PreferredSizeWidget _buildHomeAppBar(BuildContext context) {
    return AppBar(
      backgroundColor:
          widget.isPremium ? const Color(0xFFFbbc06) : AppColors.background,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      elevation: 1,
      title: Image.asset('lib/assets/images/logo_black.png', height: 60),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.store_outlined, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/marketplace');
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
            // _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ],
    );
  }
}
