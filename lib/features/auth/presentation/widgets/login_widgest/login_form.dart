import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/utils/form_validation/login_form_validation.dart';
import 'package:offgrid_nation_app/core/widgets/custom_input_field.dart';
import 'package:offgrid_nation_app/core/widgets/custom_button.dart';
import 'package:offgrid_nation_app/core/widgets/custom_loader.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/login_bloc.dart';
import './google_sign_in_button.dart';
import './apple_sign_in_button.dart';
import '../password_input_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginButtonPressed() {
    final identifier = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginSubmitted(identifier: identifier, password: password),
      );
      // if (_emailController.text == 'demouser' &&
      //     _passwordController.text == 'Demo@123') {
      //   Navigator.pushReplacementNamed(context, '/home');
      // } else {
      //   _showInvalidCredentialsAlert();
      // }
    }
  }

  void _showInvalidCredentialsAlert() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder:
            (_) => CupertinoAlertDialog(
              title: const Text('Login Failed'),
              content: const Text('Invalid credentials'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
    }
  }

  Widget _buildForgotPasswordButton() {
    return Platform.isIOS
        ? CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pushNamed(context, '/auth/reset'),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
        )
        : TextButton(
          onPressed: () => Navigator.pushNamed(context, '/auth/reset'),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        );
  }

  Widget _buildContent(LoginState state) {
    return Container(
      color: AppColors.primary,
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: AppColors.primary,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/images/image.png',
                    width: 100,
                    height: 100,
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _emailController,
                    placeholder: 'Username or Phone number',
                    keyboardType: TextInputType.text,
                    validator: LoginFormValidation.validateUsername,
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 16),
                  PasswordInput(
                    controller: _passwordController,
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildForgotPasswordButton(),
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 12),
                  CustomButton(
                    onPressed:
                        state.status == LoginStatus.loading
                            ? () {}
                            : _onLoginButtonPressed,
                    text: 'Log In',
                    backgroundColor: AppColors.background,
                    textColor: AppColors.primary,
                    height: 45,
                    width: 350,
                    borderRadius: 30,
                    loading:
                        state.status ==
                        LoginStatus
                            .loading, // Add the required 'loading' parameter
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(child: Divider(color: AppColors.background)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(color: AppColors.background),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.background)),
                    ],
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 20),
                  GoogleSignInButton(
                    loading:
                        false, // You can replace this with your state-based loading indicator if needed
                  ),
                  const SizedBox(height: 12),

                  AppleSignInButton(
                    onPressed: () {},
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/auth/signup');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppColors.background,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 800.ms),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
            );
        }
        if (state.status == LoginStatus.success) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        if (state.status == LoginStatus.loading) {
          return const CustomLoader();
        }
        return _buildContent(state);
      },
    );
  }
}
