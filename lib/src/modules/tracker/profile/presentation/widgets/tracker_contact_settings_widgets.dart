import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';

/// The contact on file, with its verification state. Shared by the email and
/// phone screens.
class TrackerContactCard extends StatelessWidget {
  const TrackerContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final String icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: AppInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.trackerSurfaceFill,
                    borderRadius: 16.circular,
                  ),
                  child: SvgPicture.asset(icon, width: 20.w, height: 20.w),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TrackerDetailText(title,
                          weight: FontWeight.w600,
                          height: 20 / 14,
                          color: AppColors.primaryWhite),
                      TrackerDetailText(value,
                          height: 20 / 14, color: AppColors.primaryWhite),
                    ],
                  ),
                ),
                12.pw,
                SvgPicture.asset(AppAssetsSvg.trackerEmailSettingsCheck,
                    width: 20.w, height: 20.w),
              ],
            ),
            16.ph,
            Container(
              width: double.infinity,
              padding: AppInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.trackerSurfaceFill,
                borderRadius: 16.circular,
                border: Border.all(color: AppColors.trackerSurfaceFill),
              ),
              child: const TrackerDetailText(AppStrings.trackerEmailVerified,
                  size: 12, height: 16 / 12, color: AppColors.primaryWhite),
            ),
          ],
        ),
      );
}

/// A preference row with its switch, shared by the email and SMS lists.
class TrackerPreferenceRow extends StatelessWidget {
  const TrackerPreferenceRow({
    super.key,
    required this.title,
    required this.note,
    required this.value,
    required this.onToggle,
    this.icon,
    this.last = false,
  });

  final String title;
  final String note;
  final bool value;
  final VoidCallback onToggle;

  /// Drawn before the title, as on the two-factor row.
  final String? icon;
  final bool last;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: last
            ? null
            : const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.trackerSurfaceFill)),
              ),
        child: Row(
          children: [
            if (icon != null) ...[
              SvgPicture.asset(icon!, width: 16.w, height: 16.w),
              8.pw,
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrackerDetailText(title,
                      weight: FontWeight.w500,
                      height: 20 / 14,
                      color: AppColors.primaryWhite),
                  2.ph,
                  TrackerDetailText(note,
                      size: 12, height: 16 / 12, color: AppColors.primaryWhite),
                ],
              ),
            ),
            12.pw,
            TrackerToggle(value: value, onTap: onToggle),
          ],
        ),
      );
}

/// Pill switch used by the email preferences.
class TrackerToggle extends StatelessWidget {
  const TrackerToggle({super.key, required this.value, this.onTap});

  final bool value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        toggled: value,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 48.w,
            height: 24.w,
            padding: AppInsets.all(2),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            decoration: BoxDecoration(
              color: value
                  ? AppColors.trackerPurpleDeep
                  : AppColors.trackerSurfaceFill,
              borderRadius: 100.circular,
              border: Border.all(color: AppColors.trackerSurfaceFill),
            ),
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryWhite,
              ),
            ),
          ),
        ),
      );
}
