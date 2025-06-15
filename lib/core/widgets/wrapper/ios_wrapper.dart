import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IOSWrapper extends StatefulWidget {
  final Widget child;
  final int currentTabIndex;
  final ValueChanged<int>? onTabSelected;
  final bool isPremium;

  const IOSWrapper({
    super.key,
    required this.child,
    this.currentTabIndex = 0,
    this.onTabSelected,
    this.isPremium = false,
  });

  @override
  _IOSWrapperState createState() => _IOSWrapperState();
}

class _IOSWrapperState extends State<IOSWrapper>
    with SingleTickerProviderStateMixin {
  bool _showIOSDrawer = false;
  late final AnimationController _drawerAnimationController;
  late final Animation<double> _drawerAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _drawerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _drawerAnimation = Tween<double>(begin: -250, end: 0).animate(
      CurvedAnimation(
        parent: _drawerAnimationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _drawerAnimationController.dispose();
    super.dispose();
  }

  void _toggleIOSDrawer() {
    setState(() {
      _showIOSDrawer = !_showIOSDrawer;
      if (_showIOSDrawer) {
        _drawerAnimationController.forward();
      } else {
        _drawerAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The main content area, leaving room for header (60) and bottom nav (60).
        Positioned.fill(top: 60, bottom: 60, child: widget.child),

        // Header
        Positioned(top: 0, left: 0, right: 0, child: _buildNavigationBar()),

        // Custom Bottom Navigation
        Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNav()),

        // iOS Drawer Overlay
        if (_showIOSDrawer) _buildDrawerOverlay(),
      ],
    );
  }

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      // Add this line to remove any default leading widget:
      leading: Container(),

      middle: Image.asset(
        'lib/assets/images/logo_black.png', // Replace with your logo path.
        height: 40,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.bag),
            onPressed: () {
              Navigator.pushNamed(context, '/marketplace');
            },
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _toggleIOSDrawer,
            child: const Icon(CupertinoIcons.line_horizontal_3),
          ),
        ],
      ),
      backgroundColor:
          widget.isPremium
              ? const Color(0xFFFbbc06)
              : Colors.white.withOpacity(0.9),
    );
  }

  /// Updated bottom nav with a semi-transparent container and rounded corners
  Widget _buildBottomNav() {
    return SafeArea(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavIcon(iconData: CupertinoIcons.home, index: 0),
            _buildNavIcon(iconData: CupertinoIcons.search, index: 1),
            _buildNavIcon(iconData: CupertinoIcons.add_circled, index: 2),
            _buildNavIcon(iconData: CupertinoIcons.chat_bubble_2, index: 3),
            _buildNavIcon(iconData: CupertinoIcons.star, index: 4),
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
        color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
      ),
    );
  }

  Widget _buildDrawerOverlay() {
    return AnimatedBuilder(
      animation: _drawerAnimationController,
      builder: (context, child) {
        return Positioned(
          left: _drawerAnimation.value,
          top: 60, // below the header
          bottom: 0,
          width: 250,
          child: Material(
            elevation: 8,
            color: Colors.white,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    // child: Text(
                    //   'Side Menu',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.home),
                    title: const Text('Home'),
                    onTap: () {
                      _toggleIOSDrawer();
                      // TODO: Navigate to Home.
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      _toggleIOSDrawer();
                      // TODO: Navigate to Settings.
                    },
                  ),
                  // Add more drawer items as needed.
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
