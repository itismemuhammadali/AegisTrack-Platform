import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../controller/tracker_share_controller.dart';
import '../widgets/tracker_share_common.dart';
import '../widgets/tracker_share_created_card.dart';
import '../widgets/tracker_share_review_card.dart';

/// Four-step Secure Share wizard, reached from the reports screen's
/// Create Secure Share Link button.
class TrackerSecureShareView extends ConsumerWidget {
  const TrackerSecureShareView({
    super.key,
    this.onCopyLink,
    this.onRevokeLink,
  });

  final VoidCallback? onCopyLink;
  final VoidCallback? onRevokeLink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerShareControllerProvider);

    return TrackerDetailScaffold(
      title: AppStrings.trackerShareTitle,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerShareBackTooltip,
      // Leaving the first step leaves the flow; later steps walk back through
      // it, so the arrow never strands the viewer mid-wizard.
      onBack: controller.isFirstStep ? null : controller.back,
      child: ListView(
        key: const PageStorageKey('tracker-secure-share'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerShareStepBar(
            count: TrackerShareController.stepCount,
            current: controller.step,
          ),
          24.ph,
          switch (controller.step) {
            0 => _TrackerShareContentStep(controller: controller),
            1 => _TrackerShareExpiryStep(controller: controller),
            2 => _TrackerShareReviewStep(controller: controller),
            _ => _TrackerShareCreatedStep(
                controller: controller,
                onCopyLink: onCopyLink ??
                    () {
                      Clipboard.setData(
                        ClipboardData(text: controller.createdUrl),
                      );
                      Prompts.showToast(
                        "Secure share link copied to clipboard!",
                      );
                    },
                onRevokeLink: onRevokeLink ??
                    () {
                      Prompts.showToast(
                        "Secure share link revoked successfully.",
                      );
                      controller.createAnother();
                    },
              ),
          },
        ],
      ),
    );
  }
}

class _TrackerShareContentStep extends StatelessWidget {
  const _TrackerShareContentStep({required this.controller});

  final TrackerShareController controller;

  @override
  Widget build(BuildContext context) => TrackerShareCard(
        title: AppStrings.trackerShareStepContentTitle,
        child: Column(
          children: [
            for (var i = 0; i < controller.contentOptions.length; i++) ...[
              TrackerShareOptionRow(
                option: controller.contentOptions[i],
                selected: controller.selectedContent == i,
                onTap: () => controller.selectContent(i),
              ),
              10.ph,
            ],
            Row(
              children: [
                Expanded(
                  child: _TrackerShareDateField(
                    date: controller.startDate,
                    onPicked: controller.setStartDate,
                  ),
                ),
                8.pw,
                Expanded(
                  child: _TrackerShareDateField(
                    date: controller.endDate,
                    firstDate: controller.startDate,
                    onPicked: controller.setEndDate,
                  ),
                ),
              ],
            ),
            16.ph,
            TrackerShareButton(
              label: AppStrings.trackerShareContinue,
              trailingIcon: AppAssetsSvg.trackerShareChevron,
              primary: true,
              onTap: controller.next,
            ),
          ],
        ),
      );
}

/// A start or end date for the shared period; tapping opens the date picker.
class _TrackerShareDateField extends StatelessWidget {
  const _TrackerShareDateField({
    required this.date,
    required this.onPicked,
    this.firstDate,
  });

  final DateTime? date;
  final DateTime? firstDate;
  final ValueChanged<DateTime> onPicked;

  static String _format(DateTime d) => '${d.month.toString().padLeft(2, '0')}/'
      '${d.day.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final first = firstDate ?? DateTime(now.year - 5);
    final picked = await showDatePicker(
      context: context,
      initialDate: date ?? (first.isAfter(now) ? first : now),
      firstDate: first,
      lastDate: now,
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _pick(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 38.h,
          padding: AppInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.trackerSurfaceFill,
            borderRadius: 20.circular,
            border: Border.all(color: AppColors.trackerSurfaceFill),
          ),
          child: Row(
            children: [
              Expanded(
                child: TrackerDetailText(
                  date == null
                      ? AppStrings.trackerShareDateHint
                      : _format(date!),
                  weight: FontWeight.w400,
                ),
              ),
              SvgPicture.asset(AppAssetsSvg.trackerShareCalendar,
                  width: 20.w, height: 20.w),
            ],
          ),
        ),
      );
}

class _TrackerShareExpiryStep extends StatelessWidget {
  const _TrackerShareExpiryStep({required this.controller});

  final TrackerShareController controller;

  @override
  Widget build(BuildContext context) => TrackerShareCard(
        title: AppStrings.trackerShareExpiryTitle,
        child: Column(
          children: [
            for (var i = 0; i < controller.expiryOptions.length; i++) ...[
              TrackerShareOptionRow(
                option: controller.expiryOptions[i],
                selected: controller.selectedExpiry == i,
                fillWhenSelected: true,
                onTap: () => controller.selectExpiry(i),
              ),
              10.ph,
            ],
            6.ph,
            _TrackerShareStepButtons(controller: controller),
          ],
        ),
      );
}

class _TrackerShareReviewStep extends StatelessWidget {
  const _TrackerShareReviewStep({required this.controller});

  final TrackerShareController controller;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TrackerShareReviewCard(rows: controller.reviewRows),
          24.ph,
          const TrackerShareTemporaryNotice(),
          24.ph,
          _TrackerShareStepButtons(
            controller: controller,
            continueLabel: AppStrings.trackerShareGenerate,
          ),
        ],
      );
}

/// Back / Continue pair shared by the expiry and review steps.
class _TrackerShareStepButtons extends StatelessWidget {
  const _TrackerShareStepButtons({
    required this.controller,
    this.continueLabel = AppStrings.trackerShareContinue,
  });

  final TrackerShareController controller;
  final String continueLabel;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TrackerShareButton(
                label: AppStrings.trackerShareBack,
                onTap: controller.back,
              ),
            ),
            12.pw,
            Expanded(
              child: TrackerShareButton(
                label: continueLabel,
                primary: true,
                onTap: controller.next,
              ),
            ),
          ],
        ),
      );
}

class _TrackerShareCreatedStep extends StatelessWidget {
  const _TrackerShareCreatedStep({
    required this.controller,
    this.onCopyLink,
    this.onRevokeLink,
  });

  final TrackerShareController controller;
  final VoidCallback? onCopyLink;
  final VoidCallback? onRevokeLink;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrackerShareCreatedCard(
            url: controller.createdUrl,
            createdAt: controller.createdAt,
            expiresAt: controller.expiresAt,
            onCopy: onCopyLink,
          ),
          24.ph,
          TrackerShareButton(
            label: AppStrings.trackerShareCopyLink,
            icon: AppAssetsSvg.trackerShareCopy,
            primary: true,
            onTap: onCopyLink,
          ),
          24.ph,
          TrackerShareButton(
            label: AppStrings.trackerShareRevokeLink,
            icon: AppAssetsSvg.trackerShareRevoke,
            borderColor: AppColors.trackerShareRevokedBorder,
            labelColor: AppColors.trackerFlaggedRed,
            onTap: onRevokeLink,
          ),
          24.ph,
          GestureDetector(
            onTap: controller.toggleAllLinks,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.trackerSurfaceFill,
                borderRadius: 16.circular,
                border: Border.all(color: AppColors.trackerSurfaceFill),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TrackerDetailText(AppStrings.trackerShareManageLinks,
                        weight: FontWeight.w500, height: 20 / 14),
                  ),
                  8.pw,
                  RotatedBox(
                    quarterTurns: controller.showAllLinks ? 1 : 0,
                    child: SvgPicture.asset(AppAssetsSvg.trackerShareChevron,
                        width: 16.w, height: 16.w),
                  ),
                ],
              ),
            ),
          ),
          if (controller.showAllLinks) ...[
            24.ph,
            Text(
              AppStrings.trackerShareAllLinks,
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                height: 16 / 12,
                fontWeight: FontWeight.w600,
                letterSpacing: .3,
                color: AppColors.primaryWhite,
              ),
            ),
            8.ph,
            for (final link in controller.links) ...[
              TrackerShareLinkCard(link: link, onRevoke: onRevokeLink),
              8.ph,
            ],
            16.ph,
            GestureDetector(
              onTap: controller.createAnother,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: AppInsets.symmetric(vertical: 12),
                  child: Text(
                    AppStrings.trackerShareCreateAnother,
                    textAlign: TextAlign.center,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 20 / 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      );
}
