import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../domain/entities/tracker_profile_row_entity.dart';
import '../controller/tracker_profile_controller.dart';
import '../widgets/tracker_help_channel_card.dart';
import '../widgets/tracker_help_faq_card.dart';
import '../widgets/tracker_help_quick_reference.dart';

/// Support contacts, portal rules and FAQs, reached from the profile's
/// Help & Support row.
class TrackerHelpSupportView extends ConsumerWidget {
  const TrackerHelpSupportView({super.key, this.onChannelSelected});

  final ValueChanged<TrackerHelpChannelEntity>? onChannelSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerProfileControllerProvider);
    final footer = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      height: 1.2,
      color: AppColors.trackerMutedText,
    );

    return TrackerDetailScaffold(
      title: AppStrings.trackerHelpSupport,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerHelpBackTooltip,
      child: ListView(
        key: const PageStorageKey('tracker-help-support'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerHelpChannelGrid(
            channels: controller.helpChannels,
            onChannelTap: onChannelSelected,
          ),
          24.ph,
          TrackerHelpQuickReference(tips: controller.helpQuickReference),
          24.ph,
          Text(
            AppStrings.trackerHelpFaqTitle,
            style: context.bodyMediumStyle?.copyWith(
              fontSize: 14.sp,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: AppColors.trackerMutedText,
            ),
          ),
          14.ph,
          for (final faq in controller.helpFaqs) ...[
            TrackerHelpFaqCard(
              question: faq,
              expanded: controller.expandedFaq == faq,
              onTap: () => controller.toggleFaq(faq),
            ),
            10.ph,
          ],
          14.ph,
          Text(AppStrings.trackerHelpFooterVersion,
              textAlign: TextAlign.center, style: footer),
          10.ph,
          Text(AppStrings.trackerHelpSupportEmail,
              textAlign: TextAlign.center, style: footer),
        ],
      ),
    );
  }
}
