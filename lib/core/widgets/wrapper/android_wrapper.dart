import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class AndroidWrapper extends StatefulWidget {
  final Widget child;
  final int currentTabIndex;
  final ValueChanged<int>? onTabSelected;
  final bool isHomeScreen;

  const AndroidWrapper({
    super.key,
    required this.child,
    this.currentTabIndex = 0,
    this.onTabSelected,
    this.isHomeScreen = false,
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
      backgroundColor: AppColors.background,
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

  // PreferredSizeWidget _buildOtherAppBar(BuildContext context) {
  //   return PreferredSize(
  //     preferredSize: const Size.fromHeight(kToolbarHeight),
  //     child: Container(
  //       color: AppColors.primary,
  //       child: SafeArea(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(left: 8.0),
  //               child: InkWell(
  //                 // onTap: () => Navigator.pop(context),
  //                 onTap: () => {},
  //                 child: Container(
  //                   width: 36,
  //                   height: 36,
  //                   decoration: const BoxDecoration(
  //                     color: Colors.white,
  //                     shape: BoxShape.circle,
  //                   ),
  //                   child: const Icon(
  //                     Icons.arrow_back,
  //                     color: AppColors.primary,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             // OFFGRID Nation logo or text on the right
  //             Padding(
  //               padding: const EdgeInsets.only(right: 16.0),
  //               child: Image.asset('lib/assets/images/image.png', height: 400),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDrawer(BuildContext context) {
  //   return Drawer(
  //     child: SafeArea(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           DrawerHeader(
  //             decoration: const BoxDecoration(color: Colors.blue),
  //             child: Image.asset('lib/assets/images/image.png', height: 20),
  //             // Row(
  //             //   children: [
  //             //     const SizedBox(width: 8),
  //             //     const Text(
  //             //       'Menu',
  //             //       style: TextStyle(color: Colors.white, fontSize: 20),
  //             //     ),
  //             //   ],
  //             // ),
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.home),
  //             title: const Text('Home'),
  //             onTap: () {
  //               Navigator.pop(context);
  //               // TODO: Navigate to Home.
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.settings),
  //             title: const Text('Settings'),
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => const SettingsPage()),
  //               );
  //             },
  //           ),
  //           // Add more drawer items here.
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
