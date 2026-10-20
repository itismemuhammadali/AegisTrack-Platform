import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_share_entity.dart';

/// Step 4: the link that was cut, with its lifetime and access.
class TrackerShareCreatedCard extends StatelessWidget {
  const TrackerShareCreatedCard({
    super.key,
    required this.url,
    required this.createdAt,
    required this.expiresAt,
    this.onCopy,
  });

  final String url;
  final String createdAt;
  final String expiresAt;
  final VoidCallback? onCopy;

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
            SvgPicture.asset(AppAssetsSvg.trackerShareSuccess,
                width: 64.w, height: 64.w),
            16.ph,
            const TrackerDetailText(AppStrings.trackerShareCreatedTitle,
                size: 18, weight: FontWeight.w600, height: 28 / 18),
            16.ph,
            Container(
              padding: AppInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.trackerSurfaceFill,
                borderRadius: 20.circular,
                border: Border.all(color: AppColors.trackerSurfaceFill),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(AppAssetsSvg.trackerShareLink,
                      width: 16.w, height: 16.w),
                  12.pw,
                  Expanded(
                    child: Text(
                      url,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodyMediumStyle?.copyWith(
                        fontSize: 14.sp,
                        height: 20 / 14,
                        fontFamily: 'monospace',
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                  12.pw,
                  GestureDetector(
                    onTap: onCopy,
                    child: SvgPicture.asset(AppAssetsSvg.trackerShareCopySmall,
                        width: 16.w, height: 16.w),
                  ),
                ],
              ),
            ),
            16.ph,
            Container(
              padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: TrackerShareLinkStatus.active.fill,
                borderRadius: 16.circular,
                border: Border.all(color: TrackerShareLinkStatus.active.border),
              ),
              child: Text(
                TrackerShareLinkStatus.active.label,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 16 / 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .3,
                  color: TrackerShareLinkStatus.active.color,
                ),
              ),
            ),
            16.ph,
            _TrackerShareDetailRow(
                label: AppStrings.trackerShareCreatedLabel, value: createdAt),
            _TrackerShareDetailRow(
                label: AppStrings.trackerShareExpiresLabel, value: expiresAt),
            const _TrackerShareDetailRow(
              label: AppStrings.trackerShareAccessLabel,
              value: AppStrings.trackerShareReadOnly,
              last: true,
            ),
          ],
        ),
      );
}

class _TrackerShareDetailRow extends StatelessWidget {
  const _TrackerShareDetailRow({
    required this.label,
    required this.value,
    this.last = false,
  });

  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.symmetric(vertical: 8),
        decoration: last
            ? null
            : const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.trackerSurfaceFill)),
              ),
        child: Row(
          children: [
            TrackerDetailText(label,
                size: 12, height: 16 / 12, color: AppColors.primaryWhite),
            8.pw,
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  height: 20 / 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.viewerSignInText,
                ),
              ),
            ),
          ],
        ),
      );
}

/// A row of the All Links list.
class TrackerShareLinkCard extends StatelessWidget {
  const TrackerShareLinkCard({super.key, required this.link, this.onRevoke});

  final TrackerShareLinkEntity link;
  final VoidCallback? onRevoke;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
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
                      Text(
                        link.url,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          height: 16 / 12,
                          fontFamily: 'monospace',
                          color: link.status.isStruckThrough
                              ? AppColors.primaryWhite
                              : AppColors.viewerSignInText,
                          decoration: link.status.isStruckThrough
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      4.ph,
                      TrackerDetailText(link.description,
                          size: 12,
                          height: 16 / 12,
                          color: AppColors.primaryWhite),
                      4.ph,
                      TrackerDetailText(
                          '${AppStrings.trackerShareExpiresPrefix}'
                          '${link.expires}',
                          size: 12,
                          height: 16 / 12,
                          color: AppColors.primaryWhite),
                    ],
                  ),
                ),
                8.pw,
                Container(
                  padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: link.status.fill,
                    borderRadius: 16.circular,
                    border: Border.all(color: link.status.border),
                  ),
                  child: TrackerDetailText(link.status.label,
                      size: 12,
                      height: 16 / 12,
                      weight: FontWeight.w600,
                      color: link.status.color),
                ),
              ],
            ),
            if (link.status.isRevocable) ...[
              8.ph,
              GestureDetector(
                onTap: onRevoke,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppAssetsSvg.trackerShareRevokeSmall,
                        width: 12.w, height: 12.w),
                    4.pw,
                    const TrackerDetailText(AppStrings.trackerShareRevokeAction,
                        size: 12,
                        height: 16 / 12,
                        weight: FontWeight.w500,
                        color: AppColors.trackerFlaggedRed),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
}
