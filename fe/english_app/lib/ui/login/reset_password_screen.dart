import 'package:english_app/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:english_app/widgets/app_text_field.dart';
import 'package:english_app/widgets/app_button.dart';
import 'package:english_app/widgets/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _submitReset() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      CustomSnackBar.show(context,
          message: 'Passwords do not match', isSuccess: false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService().resetPassword(
        token: _tokenController.text.trim(),
        newPassword: _passwordController.text,
      );

      if (result['success']) {
        CustomSnackBar.show(context,
            message: result['message'], isSuccess: true);
        Navigator.pop(context); // or redirect to login
      } else {
        CustomSnackBar.show(context,
            message: result['message'], isSuccess: false);
      }
    } catch (e) {
      CustomSnackBar.show(context, message: 'Error: $e', isSuccess: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _tokenController,
                icon: Icons.vpn_key,
                hintText: 'Enter reset token',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Token is required' : null,
              ),
              AppTextField(
                controller: _passwordController,
                icon: Icons.lock,
                hintText: 'New Password',
                isPassword: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Minimum 6 characters'
                    : null,
              ),
              AppTextField(
                controller: _confirmPasswordController,
                icon: Icons.lock_outline,
                hintText: 'Confirm Password',
                isPassword: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Confirm your password'
                    : null,
              ),
              SizedBox(height: 20),
              AppButton(
                text: 'Reset Password',
                isLoading: _isLoading,
                onPressed: _submitReset,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
