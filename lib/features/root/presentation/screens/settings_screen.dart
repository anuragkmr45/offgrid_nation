import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/widgets/custom_modal.dart';
import 'package:offgrid_nation_app/core/utils/logout_util.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> _languages = [
    'English (device\'s language)',
    'Spanish (Español)',
    'Portuguese (Português)',
    'French (français)',
    'Turkish (Türkçe)',
    'Japanese (日本語)',
  ];

  String _selectedLanguage = 'English (device\'s language)';

  void _showLanguagePicker(BuildContext context) {
    String tempSelection = _selectedLanguage;

    CustomModal.show(
      context: context,
      title: 'App language :',
      content: SizedBox(
        height: 300,
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                _languages
                    .map(
                      (lang) => RadioListTile<String>(
                        title: Text(lang),
                        value: lang,
                        groupValue: tempSelection,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          tempSelection = value!;
                          Navigator.of(context).pop(); // Close modal
                          setState(() {
                            _selectedLanguage = value;
                          });
                        },
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildTile({
    required Widget icon,
    required String title,
    String? subtitle,
    bool isProfile = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: icon,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle:
          subtitle != null
              ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: isProfile ? 1.4 : 1.2,
                  ),
                ),
              )
              : null,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget pageContent = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        buildTile(
          icon: const CircleAvatar(
            // backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            backgroundImage: NetworkImage(
              'https://res.cloudinary.com/dtxm0dakw/image/upload/v1744723246/r3hsrs6dnpr53idcjtc5.png',
            ),
            radius: 20,
          ),
          title: "Profiles",
          subtitle: "Manage your connected experience and profile setups here.",
          isProfile: true,
          onTap: () => Navigator.pushNamed(context, '/profile'),
        ),
        buildTile(
          icon: const Icon(Icons.lock, color: AppColors.textPrimary),
          title: "Privacy",
          subtitle: "Blocked accounts, Account privacy",
          onTap: () => Navigator.pushNamed(context, '/privacy'),
        ),
        buildTile(
          icon: const Icon(
            Icons.notifications_none,
            color: AppColors.textPrimary,
          ),
          title: "Notifications",
          subtitle: "Messages, liked, following & followers",
          onTap: () => Navigator.pushNamed(context, '/notifications'),
        ),
        buildTile(
          icon: const Icon(Icons.language, color: AppColors.textPrimary),
          title: "App Language",
          subtitle: _selectedLanguage,
          onTap: () => _showLanguagePicker(context),
        ),
        buildTile(
          icon: const Icon(Icons.help_outline, color: AppColors.textPrimary),
          title: "Help",
          subtitle: "Help centre / contact us",
        ),
        buildTile(
          icon: const Icon(Icons.group_outlined, color: AppColors.textPrimary),
          title: "Invite Friends",
        ),
        buildTile(
          icon: const Icon(Icons.logout, color: AppColors.textPrimary),
          title: "Log out",
          onTap: () => _showLogoutConfirmation(context),
        ),
      ],
    );

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Settings'),
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: AppColors.background,
        ),
        child: SafeArea(child: pageContent),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: pageContent,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    CustomModal.show(
      context: context,
      title: 'Confirm Logout',
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(); // Dismiss the modal first
            await LogoutUtil.logoutUser(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
