import '../../../../../core/utils/app_exports.dart';

class TrackedLogDetailsSection extends StatelessWidget {
  const TrackedLogDetailsSection(
      {super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.bodyMediumStyle?.copyWith(
            color: AppColors.primaryWhite,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
          ),
        ),
        10.ph,
        child,
      ],
    );
  }
}

class TrackedLogDetailsGlassCard extends StatelessWidget {
  const TrackedLogDetailsGlassCard(
      {super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? AppInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.trackedLogDetailsCardBackground,
        borderRadius: 16.circular,
        border: Border.all(color: AppColors.trackedLogDetailsCardBorder),
      ),
      child: child,
    );
  }
}
