import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/custom_snackbar.dart';

import '../bloc/auth_bloc.dart';
import '../widgets/otp_input.dart';

class VerifyOtpScreen extends StatefulWidget {
  final PhoneAuthCredential? phoneAuthCredential;
  final String? verificationId;
  final int? resendCode;

  const VerifyOtpScreen({
    super.key,
    this.phoneAuthCredential,
    this.verificationId,
    this.resendCode,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  late TextEditingController _pinController;
  final FocusNode _pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _pinController = TextEditingController();

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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    if (widget.phoneAuthCredential != null) {
      context.read<AuthBloc>().add(
        VerifyOtpEvent(autoCredential: widget.phoneAuthCredential),
      );
    }
  }

  void _onSubmit() {
    if (_pinController.text.isEmpty || _pinController.text.length < 6) {
      CustomSnackbar.error(
        context,
        AppLocalizations.of(context)!.provideCorrectPin,
      );

      return;
    }

    context.read<AuthBloc>().add(
      VerifyOtpEvent(
        verificationId: widget.verificationId,
        smsCode: _pinController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerified) {
            context.go('/');
          }

          if (state is VerifyOtpFailure) {
            CustomSnackbar.error(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is VerifyOtpLoading;

          return Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20.h),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appLocalizations.enterText,
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(fontWeight: FontWeight.w300),
                            ),
                            Text(
                              appLocalizations.verificationCodeText,
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Text(
                          appLocalizations.codeSentToPhone,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Center(
                          child: OtpInput(
                            pinController: _pinController,
                            pinFocusNode: _pinFocusNode,
                            isEnabled: !isLoading,
                            onCompleted: (pin) {
                              _pinFocusNode.unfocus();
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Center(
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    debugPrint('Resend code tapped');
                                  },
                            child: Text(
                              appLocalizations.resendButtonText,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FilledButton.icon(
                          onPressed: isLoading ? null : _onSubmit,
                          style: FilledButton.styleFrom(
                            minimumSize: Size(double.infinity, 56.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          icon: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                )
                              : const Icon(Icons.check_circle_outline_rounded),
                          label: Text(
                            appLocalizations.verifyText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pinController.dispose();
    _pinFocusNode.dispose();

    super.dispose();
  }
}
