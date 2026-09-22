import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../controller/tracker_users_controller.dart';
import 'tracker_detail_surface.dart';
import 'tracker_detail_text.dart';

class TrackerUserProfileCard extends StatelessWidget {
  const TrackerUserProfileCard(
      {super.key, required this.user, required this.controller});

  final TrackerUserEntity user;
  final TrackerUsersController controller;

  @override
  Widget build(BuildContext context) => TrackerDetailSurface(
        child: Row(
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.trackerPurpleDeep.withValues(alpha: .4),
                    AppColors.trackerPurpleLight.withValues(alpha: .4),
                  ],
                ),
              ),
              child: TrackerDetailText(controller.initials(user),
                  size: 20, weight: FontWeight.w700),
            ),
            16.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrackerDetailText(user.name,
                      size: 20, weight: FontWeight.w600),
                  4.ph,
                  TrackerBadge(controller.statusLabel(user),
                      color: controller.statusColor(user)),
                  4.ph,
                  const TrackerDetailText(AppStrings.trackerReadOnlyAccess,
                      size: 12, color: AppColors.trackerMutedText),
                ],
              ),
            ),
          ],
        ),
      );
}
