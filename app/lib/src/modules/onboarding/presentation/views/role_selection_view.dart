import 'dart:math' as math;

import '../../../../core/utils/app_exports.dart';
import '../widgets/onboarding_page_scaffold.dart';

/// Screen allowing the user to choose their operational role upon completing onboarding:
/// - Tracked User (Defendant / Client under supervision)
/// - Tracker / Authorized Viewer (Attorney / Bondsman / Supervisor)
class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({
    super.key,
    this.onTrackedSelected,
    this.onTrackerSelected,
  });

  final VoidCallback? onTrackedSelected;
  final VoidCallback? onTrackerSelected;

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView> {
  // 0: Tracked Individual, 1: Tracker / Counsel
  int _selectedRoleIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingScrimNavy,
      body: Stack(
        children: [
          const Positioned.fill(child: OnboardingPageBackground()),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                24.ph,
                Padding(
                  padding: AppInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        padding: AppInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhite.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryWhite.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Icon(
                          Icons.shield_outlined,
                          size: 36.sp,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                      16.ph,
                      Text(
                        "Choose Your Role",
                        textAlign: TextAlign.center,
                        style: context.headlineSmallStyle?.copyWith(
                          color: AppColors.primaryWhite,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      8.ph,
                      Text(
                        "Select how you will be interacting with the compliance monitoring system.",
                        textAlign: TextAlign.center,
                        style: context.bodyLargeStyle?.copyWith(
                          color: AppColors.signInDarkSubtitle,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          height: 22 / 15,
                        ),
                      ),
                    ],
                  ),
                ),
                28.ph,
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      24.w,
                      0,
                      24.w,
                      math.max(32.h, MediaQuery.paddingOf(context).bottom),
                    ),
                    child: Column(
                      children: [
                        _RoleOptionCard(
                          isSelected: _selectedRoleIndex == 0,
                          badgeText: "Subject / Client",
                          title: "Tracked Individual",
                          subtitle:
                              "Log location, submit selfie check-ins, record incident notes, and share tamper-proof compliance data with legal counsel.",
                          iconData: Icons.person_pin_circle_outlined,
                          onTap: () {
                            setState(() {
                              _selectedRoleIndex = 0;
                            });
                          },
                        ),
                        16.ph,
                        _RoleOptionCard(
                          isSelected: _selectedRoleIndex == 1,
                          badgeText: "Counsel / Supervisor",
                          title: "Authorized Viewer",
                          subtitle:
                              "Monitor assigned clients, inspect real-time maps and route playbacks, manage geofences, and export court-certified reports.",
                          iconData: Icons.gavel_outlined,
                          onTap: () {
                            setState(() {
                              _selectedRoleIndex = 1;
                            });
                          },
                        ),
                        32.ph,
                        PrimaryAppButton(
                          text: _selectedRoleIndex == 0
                              ? "Continue as Tracked Individual"
                              : "Continue as Authorized Viewer",
                          onTap: () {
                            if (_selectedRoleIndex == 0) {
                              widget.onTrackedSelected?.call();
                            } else {
                              widget.onTrackerSelected?.call();
                            }
                          },
                        ),
                        20.ph,
                        Text(
                          "You can switch roles later or link multiple accounts as permitted by legal authorization.",
                          textAlign: TextAlign.center,
                          style: context.bodySmallStyle?.copyWith(
                            color: AppColors.signInDarkSubtitle.withValues(alpha: 0.8),
                            fontSize: 12.sp,
                            height: 18 / 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleOptionCard extends StatelessWidget {
  const _RoleOptionCard({
    required this.isSelected,
    required this.badgeText,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.onTap,
  });

  final bool isSelected;
  final String badgeText;
  final String title;
  final String subtitle;
  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryWhite.withValues(alpha: 0.12)
              : AppColors.primaryWhite.withValues(alpha: 0.04),
          borderRadius: 18.circular,
          border: Border.all(
            color: isSelected
                ? AppColors.primaryWhite
                : AppColors.primaryWhite.withValues(alpha: 0.15),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryWhite.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: AppInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryWhite.withValues(alpha: 0.2)
                    : AppColors.primaryWhite.withValues(alpha: 0.06),
                borderRadius: 14.circular,
              ),
              child: Icon(
                iconData,
                size: 26.sp,
                color: AppColors.primaryWhite,
              ),
            ),
            14.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: context.titleMediumStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: AppInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryWhite.withValues(alpha: 0.25)
                              : AppColors.primaryWhite.withValues(alpha: 0.08),
                          borderRadius: 8.circular,
                        ),
                        child: Text(
                          badgeText,
                          style: context.labelSmallStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  8.ph,
                  Text(
                    subtitle,
                    style: context.bodyMediumStyle?.copyWith(
                      color: AppColors.signInDarkSubtitle,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      height: 18 / 13,
                    ),
                  ),
                ],
              ),
            ),
            8.pw,
            Container(
              margin: EdgeInsets.only(top: 4.h),
              width: 22.sp,
              height: 22.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryWhite : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryWhite
                      : AppColors.primaryWhite.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14.sp,
                      color: AppColors.onboardingScrimNavy,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
