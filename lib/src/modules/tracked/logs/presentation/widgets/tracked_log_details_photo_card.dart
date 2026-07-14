import '../../../../../core/utils/app_exports.dart';

class TrackedLogDetailsPhotoCard extends StatelessWidget {
  const TrackedLogDetailsPhotoCard({super.key});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: 16.circular,
        child: SizedBox(
          height: 192.h,
          width: double.infinity,
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
      );
}
