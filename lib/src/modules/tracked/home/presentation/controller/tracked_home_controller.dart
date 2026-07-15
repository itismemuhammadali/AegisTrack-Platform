import '../../../../../core/utils/app_exports.dart';

class TrackedHomeController extends ChangeNotifier with Buffers{
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
