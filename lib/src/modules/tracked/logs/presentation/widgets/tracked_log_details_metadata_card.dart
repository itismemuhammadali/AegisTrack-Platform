import '../../../../../core/utils/app_exports.dart';
import 'tracked_log_details_section.dart';

class TrackedLogDetailsMetadataCard extends StatelessWidget {
  const TrackedLogDetailsMetadataCard({super.key});

  @override
  Widget build(BuildContext context) => TrackedLogDetailsGlassCard(
        child: Column(
          children: [
            const _MetadataRow(
                AppAssetsSvg.trackedLogDetailsBattery,
                AppStrings.trackedLogDetailsBattery,
                AppStrings.trackedLogDetailsBatteryValue),
            12.ph,
            const _MetadataRow(
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
                  fontSize: 14.sp,
                  height: 20 / 14)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: AppColors.primaryWhite,
                  fontSize: 14.sp,
                  height: 20 / 14,
                  fontWeight: FontWeight.w500)),
        ],
      );
}
