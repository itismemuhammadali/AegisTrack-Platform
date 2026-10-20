import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_quick_action_entity.dart';
import 'tracker_detail_surface.dart';
import 'tracker_detail_text.dart';

class TrackerQuickActionsGrid extends StatelessWidget {
  const TrackerQuickActionsGrid(
      {super.key, required this.actions, this.onAction});

  final List<TrackerQuickActionEntity> actions;
  final ValueChanged<String>? onAction;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          for (var i = 0; i < actions.length; i += 2) ...[
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var j = i; j < i + 2 && j < actions.length; j++) ...[
                    if (j > i) 10.pw,
                    Expanded(
                      child: _TrackerQuickActionCard(
                        action: actions[j],
                        onTap: onAction == null
                            ? null
                            : () => onAction!(actions[j].label),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (i + 2 < actions.length) 10.ph,
          ],
        ],
      );
}

class _TrackerQuickActionCard extends StatelessWidget {
  const _TrackerQuickActionCard({required this.action, this.onTap});

  final TrackerQuickActionEntity action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: 16.circular,
        onTap: onTap,
        child: TrackerDetailSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.trackerSurfaceFill,
                      borderRadius: 16.circular,
                    ),
                    child: SvgPicture.asset(action.icon,
                        width: 16.w, height: 16.w),
                  ),
                  const Spacer(),
                  if (action.badge != null)
                    Container(
                      padding: AppInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: action.badgeColor,
                        borderRadius: 100.circular,
                      ),
                      child: TrackerDetailText(action.badge!,
                          size: action.badge == AppStrings.trackerBadgeExpert
                              ? 10
                              : 12,
                          weight: FontWeight.w500),
                    ),
                ],
              ),
              8.ph,
              TrackerDetailText(action.label, weight: FontWeight.w600),
            ],
          ),
        ),
      );
}
