import 'dart:async';

import '../../../../../core/utils/app_exports.dart';

/// Authentication for the tracker (authorized viewer) side of the app.
class ViewerAuthController extends ChangeNotifier with Buffers {
  final signInFormKey = GlobalKey<FormState>();
  // Prefilled in debug builds only to speed up testing.
  final emailController = TextEditingController(
    text: kDebugMode ? 'test@example.com' : null,
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? 'Test@1234' : null,
  );

  bool rememberMe = false;
  bool obscurePassword = true;
  bool isSigningIn = false;

  // Register
  final registerFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmController = TextEditingController();
  bool agreedToTerms = false;
  bool isRegistering = false;
  bool obscureRegisterPassword = true;
  bool obscureRegisterConfirm = true;

  void toggleTerms() {
    agreedToTerms = !agreedToTerms;
    notifyListeners();
  }

  void toggleRegisterPasswordVisibility() {
    obscureRegisterPassword = !obscureRegisterPassword;
    notifyListeners();
  }

  void toggleRegisterConfirmVisibility() {
    obscureRegisterConfirm = !obscureRegisterConfirm;
    notifyListeners();
  }

  void submitRegister({void Function(String email)? onSuccess}) {
    if (!(registerFormKey.currentState?.validate() ?? false)) return;
    if (!agreedToTerms) {
      Prompts.showToast(AppStrings.mustAgreeToTerms);
      return;
    }

    final email = registerEmailController.text.trim();
    isRegistering = true;
    notifyListeners();

    //  call the viewer register API before sending the code.
    isRegistering = false;
    notifyListeners();
    onSuccess?.call(email);
  }

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
    // call the resend-code API.
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

    //  verify the reset code with the API.
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

    //  save the new password through the API.
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

    //  call the viewer sign-in API.
    isSigningIn = false;
    notifyListeners();
    onSuccess?.call(email);
  }

  void submitForgotPassword({void Function(String email)? onSuccess}) {
    if (!(forgotPasswordFormKey.currentState?.validate() ?? false)) return;

    final email = forgotEmailController.text.trim();
    isSendingReset = true;
    notifyListeners();

    //  call the password-reset API.
    isSendingReset = false;
    notifyListeners();
    onSuccess?.call(email);
  }

  void signInWithBiometrics({VoidCallback? onSuccess}) {
    // prompt Face ID / fingerprint (needs local_auth) before continuing.
    onSuccess?.call();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    forgotEmailController.dispose();
    nameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    registerConfirmController.dispose();
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
