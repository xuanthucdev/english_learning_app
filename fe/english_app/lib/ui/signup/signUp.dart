import 'package:english_app/providers/auth_provider.dart';
import 'package:english_app/ui/login/login.dart';
import 'package:flutter/material.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              _buildLogo(),
              const SizedBox(height: 10),
              const Text(
                "Register Account",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              if (!authProvider.isLoading &&
                  authProvider.errorMessage != null &&
                  authProvider.errorMessage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    authProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 20),
              _buildFormFields(),
              const SizedBox(height: 20),
              AppButton(
                text: "REGISTER",
                isLoading: authProvider.isLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await authProvider.signUp(
                      fullName: _fullNameController.text.trim(),
                      email: _emailController.text.trim(),
                      phone: _phoneController.text.trim(),
                      password: _passwordController.text.trim(),
                    );

                    if (success) {
                      authProvider.clearError(); // ✅ Clear error nếu có
                      CustomSnackBar.show(
                        context,
                        message: 'Registration successful!',
                        isSuccess: true,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(),
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 15),
              _buildLoginRedirect(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'assets/images/onboarding/onboarding2.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        AppTextField(
          controller: _fullNameController,
          icon: Icons.person,
          hintText: "Full Name",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter full name';
            }
            return null;
          },
        ),
        AppTextField(
          controller: _emailController,
          icon: Icons.email,
          hintText: "Email",
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Invalid email';
            }
            return null;
          },
        ),
        AppTextField(
          controller: _phoneController,
          icon: Icons.phone,
          hintText: "Phone Number",
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value)) {
              return 'Invalid phone number';
            }
            return null;
          },
        ),
        AppTextField(
          controller: _passwordController,
          icon: Icons.lock,
          hintText: "Password",
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        AppTextField(
          controller: _confirmPasswordController,
          icon: Icons.lock_outline,
          hintText: "Confirm Password",
          isPassword: true,
          validator: (value) {
            if (value != _passwordController.text) {
              return 'Confirm password does not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      },
      child: Text.rich(
        TextSpan(
          text: "Already have an account? ",
          style: const TextStyle(fontSize: 14),
          children: [
            TextSpan(
              text: "Login now",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
