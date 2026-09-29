import '../../../../../core/utils/app_exports.dart';

class TrackedEditProfileHeader extends StatelessWidget {
  const TrackedEditProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: AppInsets.only(left: 24, right: 24, top: 12, bottom: 16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: AppBackButton(),
            ),
            Text(
              AppStrings.trackedEditProfileTitle,
              style: context.titleLargeStyle?.copyWith(
                color: AppColors.primaryWhite,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
