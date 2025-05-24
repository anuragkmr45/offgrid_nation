import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/user_profile_bloc.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(const FetchBlockedUserRequest());
  }

  @override
  Widget build(BuildContext context) {
    final bool isIOS = Platform.isIOS;

    return BlocConsumer<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state.status == UserProfileStatus.failure &&
            state.errorMessage != null) {
          final error = state.errorMessage!;
          if (isIOS) {
            showCupertinoDialog(
              context: context,
              builder:
                  (_) => CupertinoAlertDialog(
                    title: const Text('Error'),
                    content: Text(error),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
            );
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error)));
          }
        }
      },
      builder: (context, state) {
        final blockedAccounts = state.blockedUsersData?['blockedUsers'] ?? [];

        return Scaffold(
          backgroundColor: const Color(0xFF0099FF),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0099FF),
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            title: const Text(
              'Privacy',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body:
              state.status == UserProfileStatus.loading
                  ? Center(
                    child:
                        isIOS
                            ? const CupertinoActivityIndicator()
                            : const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                  )
                  : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildPrivateAccountToggle(),
                      const SizedBox(height: 20),
                      _buildBlockedAccountsHeader(),
                      const SizedBox(height: 16),
                      ...blockedAccounts
                          .map((user) => _buildBlockedUserTile(user))
                          .toList(),
                    ],
                  ),
        );
      },
    );
  }

  Widget _buildPrivateAccountToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Private Account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: true,
              onChanged: (val) {
                final isIOS = Platform.isIOS;
                if (isIOS) {
                  showCupertinoDialog(
                    context: context,
                    builder:
                        (_) => CupertinoAlertDialog(
                          title: const Text('Coming Soon'),
                          content: const Text(
                            'Private account feature is not implemented yet.',
                          ),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('OK'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Private account feature is not implemented yet.',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'When your account is public, your profile and posts can be seen by anyone, on or off Instagram, even if they don’t have an Instagram account.\n\nWhen your account is private, only the followers you approve can see what you share...',
          style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildBlockedAccountsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Blocked accounts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(Icons.add_circle, color: Colors.white),
      ],
    );
  }

  Widget _buildBlockedUserTile(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user["profilePicture"] ?? ""),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user["fullName"] ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "@${user["username"] ?? "undefined"}",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {}, // TODO: Implement unblock
            child: const Text("Unblock"),
          ),
        ],
      ),
    );
  }
}
