import '../../../../../core/utils/app_exports.dart';

/// Shared shell for the subscription screens: navy gradient backdrop and an
/// optional back button + title/subtitle header (Figma "Price plan").
class TrackedSubscriptionScaffold extends StatelessWidget {
  const TrackedSubscriptionScaffold({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
  });

  final Widget child;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.trackedLogCaptureHeaderBackdrop,
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 0.5, 1],
                colors: [
                  AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
                  AppColors.onboardingScrimNavy.withValues(alpha: 0.9),
                  AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  Padding(
                    padding: AppInsets.only(left: 24, right: 24, top: 24),
                    child: Row(
                      children: [
                        const AppBackButton(),
                        16.pw,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title!,
                                style: context.titleLargeStyle?.copyWith(
                                  color: AppColors.primaryWhite,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 28 / 20,
                                ),
                              ),
                              if (subtitle != null)
                                Text(
                                  subtitle!,
                                  style: context.bodyMediumStyle?.copyWith(
                                    color: AppColors.trackedPlanMutedText,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 20 / 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  24.ph,
                ],
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Glass card used across the subscription screens.
class TrackedSubscriptionCard extends StatelessWidget {
  const TrackedSubscriptionCard({
    super.key,
    required this.child,
    this.label,
    this.borderAlpha = 0.1,
  });

  final Widget child;
  final String? label;
  final double borderAlpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: borderAlpha),
        ),
      ),
      child: label == null
          ? child
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label!.toUpperCase(),
                  style: context.bodySmallStyle?.copyWith(
                    color: AppColors.trackedPlanMutedText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                    height: 16 / 12,
                  ),
                ),
                16.ph,
                child,
              ],
            ),
    );
  }
}
