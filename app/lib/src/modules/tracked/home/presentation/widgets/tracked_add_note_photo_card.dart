import '../../../../../core/utils/app_exports.dart';

class TrackedAddNotePhotoCard extends StatelessWidget {
  const TrackedAddNotePhotoCard({super.key, required this.onTap, this.photo});

  final VoidCallback onTap;
  final File? photo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: photo == null ? AppInsets.all(32) : AppInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(alpha: 0.05),
          borderRadius: 16.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(alpha: 0.1),
          ),
        ),
        child: photo == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 40.sp,
                    color: AppColors.trackedLogDetailsMutedText,
                  ),
                  12.ph,
                  Text(
                    AppStrings.trackedAddNoteCapturePhoto,
                    style: context.labelMediumStyle?.copyWith(
                      color: AppColors.trackedLogDetailsMutedText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: 12.circular,
                child: Image.file(
                  photo!,
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
