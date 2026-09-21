import 'dart:async';

import '../../../../../core/utils/app_exports.dart';

/// Authentication for the tracker (authorized viewer) side of the app.
class ViewerAuthController extends ChangeNotifier with Buffers {
  final signInFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscurePassword = true;
  bool isSigningIn = false;

  // Forgot password
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final forgotEmailController = TextEditingController();
  bool isSendingReset = false;

  // Reset code + new password
  static const resendDuration = 58;
  final newPasswordFormKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  List<TextEditingController?> _otpControllers = [];
  Timer? _resendTimer;
  int secondsUntilResend = resendDuration;
  bool isVerifying = false;
  bool isSavingPassword = false;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  void setOtpControllers(List<TextEditingController?> controllers) {
    _otpControllers = controllers;
  }

  void startResendTimer() {
    _resendTimer?.cancel();
    secondsUntilResend = resendDuration;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsUntilResend <= 1) {
        timer.cancel();
        secondsUntilResend = 0;
      } else {
        secondsUntilResend--;
      }
      notifyListeners();
    });
  }

  void resendCode() {
    if (secondsUntilResend != 0) return;
    // TODO: call the resend-code API.
    startResendTimer();
  }

  void verifyResetCode({VoidCallback? onSuccess}) {
    final code =
        _otpControllers.map((controller) => controller?.text ?? '').join();
    if (code.length < 6) {
      Prompts.showToast(AppStrings.enterOtpToContinue);
      return;
    }

    isVerifying = true;
    notifyListeners();

    // TODO: verify the reset code with the API.
    isVerifying = false;
    notifyListeners();
    onSuccess?.call();
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword = !obscureNewPassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

  void submitNewPassword({VoidCallback? onSuccess}) {
    if (!(newPasswordFormKey.currentState?.validate() ?? false)) return;

    isSavingPassword = true;
    notifyListeners();

    // TODO: save the new password through the API.
    isSavingPassword = false;
    notifyListeners();
    onSuccess?.call();
  }

  void toggleRememberMe() {
    rememberMe = !rememberMe;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void submitSignIn({void Function(String email)? onSuccess}) {
    if (!(signInFormKey.currentState?.validate() ?? false)) return;

    final email = emailController.text.trim();
    isSigningIn = true;
    notifyListeners();

    // TODO: call the viewer sign-in API.
    isSigningIn = false;
    notifyListeners();
    onSuccess?.call(email);
  }

  void submitForgotPassword({void Function(String email)? onSuccess}) {
    if (!(forgotPasswordFormKey.currentState?.validate() ?? false)) return;

    final email = forgotEmailController.text.trim();
    isSendingReset = true;
    notifyListeners();

    // TODO: call the password-reset API.
    isSendingReset = false;
    notifyListeners();
    onSuccess?.call(email);
  }

  void signInWithBiometrics({VoidCallback? onSuccess}) {
    // TODO: prompt Face ID / fingerprint (needs local_auth) before continuing.
    onSuccess?.call();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    forgotEmailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }
}

final viewerAuthControllerProvider =
    ChangeNotifierProvider.autoDispose<ViewerAuthController>(
  (ref) => ViewerAuthController(),
);
