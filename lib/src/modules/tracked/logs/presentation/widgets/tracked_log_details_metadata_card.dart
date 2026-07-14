import '../../../../../core/utils/app_exports.dart';
import 'tracked_log_details_section.dart';

class TrackedLogDetailsMetadataCard extends StatelessWidget {
  const TrackedLogDetailsMetadataCard({super.key});

  @override
  Widget build(BuildContext context) => const TrackedLogDetailsGlassCard(
        child: Column(
          children: [
            _MetadataRow(
                AppAssetsSvg.trackedLogDetailsBattery,
                AppStrings.trackedLogDetailsBattery,
                AppStrings.trackedLogDetailsBatteryValue),
            SizedBox(height: 12),
            _MetadataRow(
                AppAssetsSvg.trackedLogDetailsNetwork,
                AppStrings.trackedLogDetailsNetwork,
                AppStrings.trackedLogDetailsNetworkValue),
          ],
        ),
      );
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow(this.asset, this.label, this.value);
  final String asset;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SvgPicture.asset(asset, width: 16.w, height: 16.w),
          8.pw,
          Text(label,
              style: TextStyle(
                  color: AppColors.trackedLogDetailsMutedText,
                  fontSize: 14.sp)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: AppColors.primaryWhite,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500)),
        ],
      );
}
