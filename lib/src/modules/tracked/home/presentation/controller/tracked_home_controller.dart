import '../../../../../core/utils/app_exports.dart';

// Scheduled check-in flow - Joshua R Hughes (location tracking)
enum TrackedVerificationMethod { faceId, touchId, android }

enum TrackedVerificationState { idle, verifying, verified }

class TrackedHomeController extends ChangeNotifier with Buffers {
  final TextEditingController noteController = TextEditingController();
  File? photo;
  bool isSaving = false;

  void setPhoto(File? file) {
    photo = file;
    notifyListeners();
  }

  Future<void> save({VoidCallback? onSaved}) async {
    if (isSaving) return;
    isSaving = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    isSaving = false;
    notifyListeners();
    onSaved?.call();
  }

  // Scheduled check-in flow
  TrackedVerificationMethod method = Platform.isAndroid
      ? TrackedVerificationMethod.android
      : TrackedVerificationMethod.faceId;
  TrackedVerificationState verificationState = TrackedVerificationState.idle;
  File? selfie;
  DateTime? completedAt;

  bool get isVerifying =>
      verificationState == TrackedVerificationState.verifying;
  bool get isVerified => verificationState == TrackedVerificationState.verified;

  void selectMethod(TrackedVerificationMethod value) {
    if (verificationState != TrackedVerificationState.idle) return;
    method = value;
    notifyListeners();
  }

  Future<void> startVerification() async {
    if (verificationState != TrackedVerificationState.idle) return;
    verificationState = TrackedVerificationState.verifying;
    notifyListeners();
    // replace with local_auth biometric prompt for [method].
    await Future.delayed(const Duration(seconds: 2));
    verificationState = TrackedVerificationState.verified;
    notifyListeners();
  }

  Future<void> captureSelfie() async {
    final File? file;
    try {
      file = await AppImagePicker.fromCamera(preferFront: true);
    } on PlatformException {
      Prompts.showToast(AppStrings.selfieCameraUnavailable);
      return;
    }
    if (file == null) return;
    selfie = file;
    notifyListeners();
  }

  void retakeSelfie() {
    selfie = null;
    notifyListeners();
  }

  void confirmCheckIn() {
    // upload selfie + location and create the check-in log.
    completedAt = DateTime.now();
    notifyListeners();
  }

  void resetCheckIn() {
    verificationState = TrackedVerificationState.idle;
    selfie = null;
    completedAt = null;
    notifyListeners();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}

final trackedHomeControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackedHomeController>(
  (ref) => TrackedHomeController(),
);
