import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_security_check_entity.dart';
import 'tracker_detail_text.dart';

class TrackerSecurityCheckCard extends StatelessWidget {
  const TrackerSecurityCheckCard({super.key, required this.check});

  final TrackerSecurityCheckEntity check;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TrackerDetailText(check.label,
                      weight: FontWeight.w500,
                      color: AppColors.primaryWhite,
                      height: 20 / 14),
                ),
                8.pw,
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: check.background,
                        borderRadius: 100.circular,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(check.icon,
                              width: 12.w, height: 12.w),
                          4.pw,
                          Flexible(
                            child: TrackerDetailText(check.status,
                                size: 12,
                                weight: FontWeight.w500,
                                color: check.color,
                                height: 16 / 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (check.description != null) ...[
              6.ph,
              TrackerDetailText(check.description!,
                  size: 12, color: AppColors.primaryWhite, height: 16 / 12),
            ],
          ],
        ),
      );
}
