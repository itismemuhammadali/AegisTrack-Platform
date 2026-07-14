import '../../../../../core/utils/app_exports.dart';

class AuthController extends ChangeNotifier {
  bool isSigningIn = false;
  bool isVerifying = false;
  bool isResending = false;
  bool isVerifyingTwoFactor = false;

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

  void resendOtp({required String email}) {
    isResending = true;
    notifyListeners();

    isResending = false;
    notifyListeners();
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
}

final authControllerProvider = ChangeNotifierProvider<AuthController>(
  (ref) => AuthController(),
);
