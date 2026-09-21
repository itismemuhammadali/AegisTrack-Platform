import 'dart:async';

import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_subscription_plan_entity.dart';

class AuthController extends ChangeNotifier {
  static const resendDuration = 58;

  final signInFormKey = GlobalKey<FormState>();
  // Prefilled in debug builds only to speed up testing.
  final emailController = TextEditingController(
    text: kDebugMode ? 'test@example.com' : null,
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? 'Test@1234' : null,
  );

  // Register
  final registerFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool agreedToTerms = false;
  bool isRegistering = false;
  bool obscureRegisterPassword = true;
  bool obscureConfirmPassword = true;

  List<TextEditingController?> _verificationOtpControllers = [];
  List<TextEditingController?> _twoFactorOtpControllers = [];
  Timer? _resendTimer;

  bool isSigningIn = false;
  bool isVerifying = false;
  bool isResending = false;
  bool isVerifyingTwoFactor = false;
  bool obscurePassword = true;
  bool trustDevice = false;
  int secondsUntilResend = resendDuration;
  TrackedSubscriptionPlan selectedPlan = TrackedSubscriptionPlan.basic;
  bool isConfirmingSubscription = false;

  void toggleTerms() {
    agreedToTerms = !agreedToTerms;
    notifyListeners();
  }

  void toggleRegisterPasswordVisibility() {
    obscureRegisterPassword = !obscureRegisterPassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
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

    // TODO: call the register API before sending the verification code.
    isRegistering = false;
    notifyListeners();
    onSuccess?.call(email);
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void setVerificationOtpControllers(
    List<TextEditingController?> controllers,
  ) {
    _verificationOtpControllers = controllers;
  }

  void setTwoFactorOtpControllers(List<TextEditingController?> controllers) {
    _twoFactorOtpControllers = controllers;
  }

  void setTrustDevice(bool value) {
    if (trustDevice == value) return;
    trustDevice = value;
    notifyListeners();
  }

  void submitSignIn({
    void Function(String email, String password)? onSuccess,
  }) {
    if (!(signInFormKey.currentState?.validate() ?? false)) return;

    final email = emailController.text.trim();
    final password = passwordController.text;
    signIn(
      email: email,
      password: password,
      onSuccess: () => onSuccess?.call(email, password),
    );
  }

  void signIn({
    required String email,
    required String password,
    VoidCallback? onSuccess,
  }) {
    isSigningIn = true;
    notifyListeners();

    isSigningIn = false;
    notifyListeners();
    onSuccess?.call();
  }

  void submitVerification({
    required String email,
    void Function(String code)? onSuccess,
  }) {
    final code = _readOtp(_verificationOtpControllers);
    verifyOtp(
      email: email,
      code: code,
      onSuccess: () => onSuccess?.call(code),
    );
  }

  void verifyOtp({
    required String email,
    required String code,
    VoidCallback? onSuccess,
  }) {
    isVerifying = true;
    notifyListeners();

    isVerifying = false;
    notifyListeners();
    onSuccess?.call();
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

  void resendOtp({required String email, VoidCallback? onResend}) {
    if (secondsUntilResend != 0) return;

    isResending = true;
    notifyListeners();

    startResendTimer();
    isResending = false;
    notifyListeners();
    onResend?.call();
  }

  void submitTwoFactor({void Function(String code)? onSuccess}) {
    final code = _readOtp(_twoFactorOtpControllers);
    verifyTwoFactorCode(
      code: code,
      trustDevice: trustDevice,
      onSuccess: () => onSuccess?.call(code),
    );
  }

  void verifyTwoFactorCode({
    required String code,
    required bool trustDevice,
    VoidCallback? onSuccess,
  }) {
    isVerifyingTwoFactor = true;
    notifyListeners();

    isVerifyingTwoFactor = false;
    notifyListeners();
    onSuccess?.call();
  }

  void selectPlan(TrackedSubscriptionPlan plan) {
    if (selectedPlan == plan) return;
    selectedPlan = plan;
    notifyListeners();
  }

  void confirmSubscription({VoidCallback? onSuccess}) {
    isConfirmingSubscription = true;
    notifyListeners();

    isConfirmingSubscription = false;
    notifyListeners();
    onSuccess?.call();
  }

  String _readOtp(List<TextEditingController?> controllers) =>
      controllers.map((controller) => controller?.text ?? '').join();

  @override
  void dispose() {
    _resendTimer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

final authControllerProvider = ChangeNotifierProvider<AuthController>(
  (ref) => AuthController(),
);
