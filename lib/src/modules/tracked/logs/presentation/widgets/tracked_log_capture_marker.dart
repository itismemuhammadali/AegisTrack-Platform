import '../../../../../core/utils/app_exports.dart';

class TrackedLogCaptureMarker extends StatelessWidget {
  const TrackedLogCaptureMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.trackedLogDetailsCardBackground,
        border: Border.all(color: AppColors.trackedLogDetailsCardBorder),
      ),
      child: SvgPicture.asset(
        AppAssetsSvg.trackedLogDetailsLocation,
        width: 60.sp,
        height: 60.sp,
      ),
    );
  }
}
