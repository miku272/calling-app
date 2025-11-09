import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/phone_input_field.dart';

import '../bloc/auth_bloc.dart';

import '../widgets/auth_header.dart';
import '../widgets/terms_checkbox.dart';
import '../widgets/or_divider.dart';
import '../widgets/social_auth_button.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/password_strength_indicator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  // Store the country dial code from PhoneInputField
  String _countryDialCode = '+1';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }

    // Validate that we have a valid country code + phone number combination
    final fullNumber = '$_countryDialCode$value';
    if (fullNumber.length < 10) {
      return 'Phone number is too short';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleSignup() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      SignUpWithEmailAndPasswordEvent(
        displayName: _nameController.text.trim(),
        phoneNumber:
            '${_countryDialCode.trim()}${_phoneController.text.trim()}',
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _handleSocialAuth(String provider) {
    CustomSnackbar.info(context, 'Continue with $provider coming soon!');
  }

  void _navigateToLogin() {
    final canPop = context.canPop();
    if (canPop) {
      context.replace('/login');
    } else {
      context.go('/login');
    }
  }

  void _showTerms() {
    CustomSnackbar.info(context, 'Terms & Conditions screen coming soon!');
  }

  void _showPrivacy() {
    CustomSnackbar.info(context, 'Privacy Policy screen coming soon!');
  }

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();

    return Scaffold(
      appBar: canPop ? AppBar() : null,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignUpWithEmailAndPasswordSuccess) {
            CustomSnackbar.success(context, 'Sign up successful!');
          }

          if (state is SignUpWithEmailAndPasswordFailure) {
            CustomSnackbar.error(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is SignUpWithEmailAndPasswordLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const AuthHeader(
                      title: 'Create Account',
                      subtitle: 'Sign up to get started with your new account',
                    ),
                    const SizedBox(height: 32),

                    // Name field
                    TextFormField(
                      controller: _nameController,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.name],
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),

                    // Phone field with country code picker
                    PhoneInputField(
                      controller: _phoneController,
                      enabled: !isLoading,
                      validator: _validatePhone,
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      initialCountryCode: 'US',
                      favoriteCountries: const ['+1', '+91', '+44', '+61'],
                      onCountryChanged: (dialCode) {
                        setState(() {
                          _countryDialCode = dialCode;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: _validatePassword,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    // Password strength indicator
                    PasswordStrengthIndicator(
                      password: _passwordController.text,
                      show: _passwordController.text.isNotEmpty,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 24),

                    // Terms checkbox
                    TermsCheckbox(
                      value: _acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptedTerms = value ?? false;
                        });
                      },
                      onTermsTap: _showTerms,
                      onPrivacyTap: _showPrivacy,
                    ),
                    const SizedBox(height: 32),

                    // Sign up button
                    ElevatedButton(
                      onPressed: isLoading ? null : _handleSignup,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Sign Up'),
                    ),
                    const SizedBox(height: 24),

                    // OR divider
                    const OrDivider(text: 'Or continue with'),
                    const SizedBox(height: 24),

                    // Social auth buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 16,
                      children: [
                        Expanded(
                          child: SocialAuthButton(
                            provider: 'Google',
                            icon: Icons.g_mobiledata,
                            onPressed: () => _handleSocialAuth('Google'),
                          ),
                        ),
                        Expanded(
                          child: SocialAuthButton(
                            provider: 'Apple',
                            icon: Icons.apple,
                            onPressed: () => _handleSocialAuth('Apple'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Footer link
                    AuthFooterLink(
                      questionText: 'Already have an account?',
                      actionText: 'Login',
                      onActionTap: _navigateToLogin,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
