import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/country_code_widget.dart';

import '../../../../core/widgets/custom_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/phone_number_field.dart';

class EnterNumberScreen extends StatefulWidget {
  const EnterNumberScreen({super.key});

  @override
  State<EnterNumberScreen> createState() => _EnterNumberScreenState();
}

class _EnterNumberScreenState extends State<EnterNumberScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  String? _countryCode = '91';
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _phoneNumberController = TextEditingController();

    // Start the animation
    _animationController.forward();
  }

  void _onCountryCodeChanged(CountryCode countryCode) {
    setState(() {
      _countryCode = countryCode.dialCode;
    });
  }

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final phoneNumber =
        '+${_countryCode?.trim()}${_phoneNumberController.text.trim()}';

    context.read<AuthBloc>().add(SendOtpEvent(phoneNumber: phoneNumber));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AutomaticallyVerified) {
              context.go('/verify-otp', extra: state.phoneAuthCredential);
            }

            if (state is OtpSent) {
              context.go(
                '/verify-otp?verificationId=${state.verificationCode}&resendToken=${state.resendToken}',
              );
            }

            if (state is SendOtpFailure) {
              CustomSnackbar.error(context, state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is SendOtpLoading;

            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Image.asset(
                      'assets/images/hero_enter_phone_number.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10.h),
                                Text(
                                  'Enter your',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  'phone number',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          SlideTransition(
                            position: _slideAnimation,
                            child: Text(
                              'We\'ll send you a verification code',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          SlideTransition(
                            position: _slideAnimation,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 100.w,
                                        child: CountryCodeWidget(
                                          onChanged: _onCountryCodeChanged,
                                          initialSelection: 'IN',
                                          isEnabled: !isLoading,
                                        ),
                                      ),
                                      Expanded(
                                        child: PhoneNumberField(
                                          phoneNumberController:
                                              _phoneNumberController,
                                          isEnabled: !isLoading,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 32.h),
                                  FilledButton.icon(
                                    onPressed: isLoading ? null : _onContinue,
                                    style: FilledButton.styleFrom(
                                      minimumSize: Size(double.infinity, 56.h),
                                    ),
                                    icon: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(),
                                          )
                                        : const Icon(
                                            Icons.arrow_forward_rounded,
                                          ),
                                    label: const Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SlideTransition(
                            position: _slideAnimation,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 24.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_outline,
                                    size: 16.sp,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                  SizedBox(width: 8.w),
                                  Flexible(
                                    child: Text(
                                      'Your information is secure and encrypted',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }
}
