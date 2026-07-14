import '../../../../../core/utils/app_exports.dart';

class TrackedLogDetailsPhotoCard extends StatelessWidget {
  const TrackedLogDetailsPhotoCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackedLogDetailsCardBorder),
        ),
        child: SizedBox(
          height: 192.h,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: 16.circular,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(AppAssetsSvg.trackedLogDetailsPhoto,
                    fit: BoxFit.cover),
                Center(
                    child: SvgPicture.asset(
                        AppAssetsSvg.trackedLogDetailsPhotoIcon,
                        width: 64.w,
                        height: 64.w)),
              ],
            ),
          ),
        ),
      );
}
