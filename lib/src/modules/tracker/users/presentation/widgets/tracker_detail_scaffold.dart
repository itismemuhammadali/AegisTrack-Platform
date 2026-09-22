import '../../../../../core/utils/app_exports.dart';
import 'tracker_detail_text.dart';

/// Gradient scaffold with a back button shared by the viewer detail screens.
class TrackerDetailScaffold extends StatelessWidget {
  const TrackerDetailScaffold({
    super.key,
    required this.title,
    required this.backTooltip,
    required this.child,
    this.header,
    this.subtitle,
    this.trailing,
    this.titleColor = AppColors.viewerSignInText,
    this.backgroundColor = AppColors.trackedDashboardBackground,
    this.scrimColor = AppColors.onboardingScrimNavy,
    this.secondaryScrimColor,
    this.scrimAlpha = .4,
    this.midScrimAlpha = .9,
  });

  final String title;
  final String backTooltip;
  final String? subtitle;

  /// Replaces the default back-arrow header row, for screens whose header is
  /// laid out differently (the case detail closes rather than going back).
  final Widget? header;

  /// Optional action shown at the end of the header row.
  final Widget? trailing;
  final Widget child;
  final Color titleColor;
  final Color backgroundColor;
  final Color scrimColor;
  final Color? secondaryScrimColor;
  final double scrimAlpha;
  final double midScrimAlpha;

  @override
  Widget build(BuildContext context) {
    final midColor = secondaryScrimColor ?? scrimColor;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, .5, 1],
            colors: [
              scrimColor.withValues(alpha: scrimAlpha),
              midColor.withValues(alpha: midScrimAlpha),
              scrimColor.withValues(alpha: scrimAlpha),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    AppInsets.only(left: 24, right: 24, top: 24, bottom: 16),
                child: header ??
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 40.w,
                          height: 40.w,
                          child: IconButton(
                            tooltip: backTooltip,
                            onPressed: () => Navigator.of(context).pop(),
                            padding: EdgeInsets.zero,
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.trackerSurfaceFill,
                              shape: RoundedRectangleBorder(
                                borderRadius: 18.circular,
                                side: const BorderSide(
                                    color: AppColors.trackerBorderSoft),
                              ),
                            ),
                            icon: SvgPicture.asset(
                              AppAssetsSvg.trackerUserDetailBack,
                              width: 20.w,
                              height: 20.w,
                            ),
                          ),
                        ),
                        16.pw,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TrackerDetailText(title,
                                  size: 24,
                                  weight: FontWeight.w600,
                                  color: titleColor,
                                  height: 32 / 24),
                              if (subtitle != null) ...[
                                4.ph,
                                TrackerDetailText(subtitle!,
                                    size: 12,
                                    color: AppColors.primaryWhite,
                                    height: 16 / 12),
                              ],
                            ],
                          ),
                        ),
                        if (trailing != null) ...[16.pw, trailing!],
                      ],
                    ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
