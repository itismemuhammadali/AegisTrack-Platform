import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_log_entry_entity.dart';
import '../widgets/tracked_log_details_additional_notes.dart';
import '../widgets/tracked_log_details_header.dart';
import '../widgets/tracked_log_details_location_card.dart';
import '../widgets/tracked_log_details_map_preview.dart';
import '../widgets/tracked_log_details_metadata_card.dart';
import '../widgets/tracked_log_details_photo_card.dart';
import '../widgets/tracked_log_details_section.dart';

class TrackedLogDetailsView extends StatelessWidget {
  const TrackedLogDetailsView({super.key, this.entry});

  final TrackedLogEntryEntity? entry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.trackedDashboardBackground,
      body: DecoratedBox(
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
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const TrackedLogDetailsHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppInsets.only(left: 24, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TrackedLogDetailsMapPreview(),
                      24.ph,
                      TrackedLogDetailsLocationCard(
                        location: entry?.location ??
                            AppStrings.trackedLogDetailsDefaultLocation,
                      ),
                      24.ph,
                      const TrackedLogDetailsSection(
                        title: AppStrings.logTagNote,
                        child: TrackedLogDetailsGlassCard(
                          child: Text(
                            AppStrings.trackedLogDetailsNote,
                            style: TextStyle(
                              color: AppColors.trackedLogDetailsMutedText,
                              fontSize: 14,
                              height: 1.62,
                            ),
                          ),
                        ),
                      ),
                      24.ph,
                      const TrackedLogDetailsSection(
                        title: AppStrings.logTagPhoto,
                        child: TrackedLogDetailsPhotoCard(),
                      ),
                      24.ph,
                      const TrackedLogDetailsSection(
                        title: AppStrings.trackedLogDetailsMetadata,
                        child: TrackedLogDetailsMetadataCard(),
                      ),
                      24.ph,
                      const TrackedLogDetailsAdditionalNotes(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
