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
    super.dispose();
  }
}

final viewerAuthControllerProvider =
    ChangeNotifierProvider.autoDispose<ViewerAuthController>(
  (ref) => ViewerAuthController(),
);
