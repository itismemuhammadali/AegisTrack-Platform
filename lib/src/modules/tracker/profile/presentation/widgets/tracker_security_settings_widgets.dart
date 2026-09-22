import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_profile_row_entity.dart';

/// Overall account security, at the top of the screen.
class TrackerSecurityStatusCard extends StatelessWidget {
  const TrackerSecurityStatusCard({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: AppInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.trackerNeutralSurface,
                    borderRadius: 20.circular,
                  ),
                  child: SvgPicture.asset(
                      AppAssetsSvg.trackerSecurityStatusShield,
                      width: 24.w,
                      height: 24.w),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TrackerDetailText(AppStrings.trackerSecurityStatus,
                          size: 20,
                          weight: FontWeight.w600,
                          height: 30 / 20,
                          color: AppColors.primaryWhite),
                      2.ph,
                      const TrackerDetailText(
                          AppStrings.trackerSecurityStatusValue,
                          height: 20 / 14,
                          color: AppColors.trackerMutedText),
                    ],
                  ),
                ),
              ],
            ),
            16.ph,
            const TrackerDetailText(AppStrings.trackerSecurityStatusNote,
                height: 20 / 14, color: AppColors.primaryWhite),
          ],
        ),
      );
}

/// A signed-in device, with the action to sign it out.
class TrackerSessionRow extends StatelessWidget {
  const TrackerSessionRow({
    super.key,
    required this.session,
    this.onRevoke,
    this.last = false,
  });

  final TrackerSessionEntity session;
  final VoidCallback? onRevoke;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 4.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          TrackerDetailText(session.device,
                              weight: FontWeight.w500,
                              height: 20 / 14,
                              color: AppColors.primaryWhite),
                          if (session.isCurrent)
                            Container(
                              padding: AppInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.trackerSurfaceFill,
                                borderRadius: 4.circular,
                              ),
                              child: const TrackerDetailText(
                                  AppStrings.trackerSecuritySessionCurrent,
                                  size: 12,
                                  height: 16 / 12,
                                  color: AppColors.primaryWhite),
                            ),
                        ],
                      ),
                      4.ph,
                      TrackerDetailText(session.location,
                          size: 12,
                          height: 16 / 12,
                          color: AppColors.primaryWhite),
                    ],
                  ),
                ),
                // The device in use cannot be signed out from itself.
                if (!session.isCurrent) ...[
                  8.pw,
                  GestureDetector(
                    onTap: onRevoke,
                    behavior: HitTestBehavior.opaque,
                    child: const TrackerDetailText(
                        AppStrings.trackerSecuritySessionRevoke,
                        size: 12,
                        weight: FontWeight.w500,
                        height: 16 / 12,
                        color: AppColors.trackerCriticalRed),
                  ),
                ],
              ],
            ),
            8.ph,
            TrackerDetailText(session.lastActive,
                size: 12, height: 16 / 12, color: AppColors.primaryWhite),
          ],
        ),
      );
}

/// Card with a titled header strip over a list of rows.
class TrackerSecuritySection extends StatelessWidget {
  const TrackerSecuritySection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: AppInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.trackerSurfaceFill)),
              ),
              child: TrackerDetailText(title,
                  size: 20,
                  weight: FontWeight.w600,
                  height: 30 / 20,
                  color: AppColors.primaryWhite),
            ),
            ...children,
          ],
        ),
      );
}
