import '../../../../../components/custom_textfield.dart';
import '../../../../../components/image_source_sheet.dart';
import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_home_controller.dart';
import '../widgets/tracked_add_note_action_bar.dart';
import '../widgets/tracked_add_note_header.dart';
import '../widgets/tracked_add_note_photo_card.dart';

class TrackedAddNoteView extends ConsumerWidget {
  const TrackedAddNoteView({super.key, this.onSaved});

  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedHomeControllerProvider);
    final fieldFillColor = AppColors.primaryWhite.withValues(alpha: 0.05);
    final fieldBorderColor = AppColors.primaryWhite.withValues(alpha: 0.1);

    return Scaffold(
      backgroundColor: AppColors.trackedLogCaptureHeaderBackdrop,
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 0.5, 1],
                colors: [
                  AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
                  AppColors.onboardingScrimNavy.withValues(alpha: 0.9),
                  AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                const TrackedAddNoteHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppInsets.only(left: 24, right: 24, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.trackedAddNoteNoteLabel,
                          style: context.labelLargeStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.ph,
                        CustomTextField(
                          controller: controller.noteController,
                          hintText: AppStrings.trackedAddNoteHint,
                          minLines: 7,
                          maxLines: 7,
                          textCapitalization: TextCapitalization.sentences,
                          textStyle: context.bodyLargeStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 16.sp,
                          ),
                          hintTextStyle: context.bodyLargeStyle?.copyWith(
                            color: AppColors.hintGray,
                            fontSize: 16.sp,
                          ),
                          fillColor: fieldFillColor,
                          enableBorderColor: fieldBorderColor,
                          focusedBorderColor: fieldBorderColor,
                          fieldBorderRadius: 16,
                          contentPadding: AppInsets.all(16),
                        ),
                        24.ph,
                        Text(
                          AppStrings.trackedAddNotePhotoLabel,
                          style: context.labelLargeStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.ph,
                        TrackedAddNotePhotoCard(
                          photo: controller.photo,
                          onTap: () => ImageSourceSheet.show(
                            context,
                            isDark: true,
                            onPicked: controller.setPhoto,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TrackedAddNoteActionBar(
                  isSaving: controller.isSaving,
                  onSave: () =>
                      controller.save(onSaved: onSaved ?? AppRouterGo.back),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
