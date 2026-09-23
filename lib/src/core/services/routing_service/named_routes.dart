// ignore_for_file: strict_top_level_inference

// This is also known as declerative routing

import '../../../modules/tracker/cases/domain/entities/tracker_case_entity.dart';
import '../../../modules/tracker/cases/presentation/views/tracker_case_detail_view.dart';
import '../../../modules/tracker/notifications/presentation/views/tracker_notifications_view.dart';
import '../../../modules/tracker/profile/presentation/views/tracker_edit_profile_view.dart';
import '../../../modules/tracker/profile/presentation/views/tracker_email_settings_view.dart';
import '../../../modules/tracker/profile/presentation/views/tracker_phone_number_view.dart';
import '../../../modules/tracker/profile/presentation/views/tracker_display_theme_view.dart';
import '../../../modules/tracker/profile/presentation/views/tracker_notification_settings_view.dart';
import '../../../modules/tracker/profile/presentation/views/tracker_security_settings_view.dart';
import '../../../modules/tracker/profile/presentation/views/tracker_help_support_view.dart';
import '../../../modules/tracker/profile/presentation/views/tracker_plan_subscription_view.dart';
import '../../../modules/tracker/reports/presentation/views/tracker_reports_view.dart';
import '../../../modules/tracker/share/presentation/views/tracker_secure_share_view.dart';
import '../../../modules/tracker/users/presentation/views/tracker_ai_insights_view.dart';
import '../../../modules/tracker/users/presentation/views/tracker_check_ins_view.dart';
import '../../../modules/tracker/users/presentation/views/tracker_live_tracking_view.dart';
import '../../../modules/tracker/users/presentation/views/tracker_log_detail_view.dart';
import '../../../modules/tracker/users/presentation/views/tracker_map_playback_view.dart';
import '../../../modules/tracker/users/presentation/views/tracker_security_details_view.dart';
import '../../../modules/tracker/users/presentation/views/tracker_timeline_view.dart';
import '../../../modules/tracker/users/presentation/views/tracker_user_details_view.dart';
import '../../../modules/tracker/home/domain/entities/tracker_user_entity.dart';
import '../../../modules/onboarding/presentation/views/onboarding_view.dart';
import '../../../modules/tracked/authentication/presentation/views/enable_location_access_view.dart';
import '../../../modules/tracked/authentication/presentation/views/register_view.dart';
import '../../../modules/tracker/authentication/presentation/views/viewer_forgot_password_view.dart';
import '../../../modules/tracker/dashboard/presentation/views/tracker_dashboard_view.dart';
import '../../../modules/tracker/authentication/presentation/views/viewer_new_password_view.dart';
import '../../../modules/tracker/authentication/presentation/views/viewer_register_view.dart';
import '../../../modules/tracker/authentication/presentation/views/viewer_sign_in_view.dart';
import '../../../modules/tracker/authentication/presentation/views/viewer_verify_view.dart';
import '../../../modules/tracked/authentication/presentation/views/sign_in_options_view.dart';
import '../../../modules/tracked/authentication/presentation/views/sign_in_view.dart';
import '../../../modules/tracked/authentication/presentation/views/two_factor_view.dart';
import '../../../modules/tracked/authentication/presentation/views/verify_view.dart';
import '../../../modules/tracked/dashboard/presentation/views/tracked_dashboard_view.dart';
import '../../../modules/tracked/logs/domain/entities/tracked_log_entry_entity.dart';
import '../../../modules/tracked/home/presentation/views/tracked_add_note_view.dart';
import '../../../modules/tracked/home/presentation/views/tracked_live_map_view.dart';
import '../../../modules/tracked/home/presentation/views/tracked_log_capture_view.dart';
import '../../../modules/tracked/home/presentation/views/tracked_review_image_view.dart';
import '../../../modules/tracked/home/presentation/views/tracked_capture_image_view.dart';
import '../../../modules/tracked/home/presentation/views/tracked_check_in_complete_view.dart';
import '../../../modules/tracked/home/presentation/views/tracked_check_in_verify_view.dart';
import '../../../modules/tracked/home/presentation/views/tracked_check_ins_view.dart';
import '../../../modules/tracked/home/presentation/views/tracked_selfie_capture_view.dart';
import '../../../modules/tracked/home/presentation/views/tracked_sos_view.dart';
import '../../../modules/tracked/home/presentation/views/tracked_zone_status_view.dart';
import '../../../modules/tracked/logs/presentation/views/tracked_log_details_view.dart';
import '../../../modules/tracked/settings/presentation/views/tracked_anti_spoofing_view.dart';
import '../../../modules/tracked/settings/presentation/views/tracked_edit_profile_view.dart';
import '../../../modules/tracked/settings/presentation/views/tracked_export_center_view.dart';
import '../../../modules/tracked/settings/presentation/views/tracked_membership_view.dart';
import '../../../modules/tracked/settings/presentation/views/tracked_sync_status_view.dart';
import '../../../modules/tracked/authentication/presentation/views/tracked_choose_plan_view.dart';
import '../../../modules/tracked/authentication/presentation/views/tracked_confirm_subscription_view.dart';
import '../../../modules/tracked/authentication/presentation/views/tracked_subscription_active_view.dart';
import '../../utils/app_exports.dart';

class AppRouterGo {
  static BuildContext get context =>
      appRouter.routerDelegate.navigatorKey.currentContext!;

  static final appRouter = GoRouter(
    routes: [
      GoRoute(
        path: onboardingView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: OnboardingView(
            onGetStarted: () => AppRouterGo.push(signInOptionsView),
          ),
        ),
      ),
      GoRoute(
        path: signInOptionsView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: SignInOptionsView(
            onEmailSignIn: () => AppRouterGo.push(signInView),
            onViewerAccount: () => AppRouterGo.push(viewerSignInView),
          ),
        ),
      ),
      GoRoute(
        path: signInView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: SignInView(
            onSignIn: (email, password) =>
                AppRouterGo.push(verifyView, extra: email),
            onRegister: () => AppRouterGo.push(registerView),
          ),
        ),
      ),
      GoRoute(
        path: trackerSecurityDetailsView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackerSecurityDetailsView(
            user: state.extra as TrackerUserEntity?,
            onViewRelatedLog: () =>
                AppRouterGo.push(trackerLogDetailView, extra: state.extra),
          ),
        ),
      ),
      GoRoute(
        path: trackerUserDetailsView,
        redirect: (context, state) =>
            state.extra is TrackerUserEntity ? null : trackerDashboardView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackerUserDetailsView(
            user: state.extra! as TrackerUserEntity,
            onSecurityDetails: () => AppRouterGo.push(
                trackerSecurityDetailsView,
                extra: state.extra),
            onActivitySelected: (_) =>
                AppRouterGo.push(trackerLogDetailView, extra: state.extra),
            onAction: (action) => switch (action) {
              AppStrings.trackerActionTimeline =>
                AppRouterGo.push(trackerTimelineView, extra: state.extra),
              AppStrings.trackerActionMapPlayback =>
                AppRouterGo.push(trackerMapPlaybackView, extra: state.extra),
              AppStrings.trackerActionLiveView =>
                AppRouterGo.push(trackerLiveTrackingView, extra: state.extra),
              AppStrings.trackerActionCheckIns =>
                AppRouterGo.push(trackerCheckInsView, extra: state.extra),
              AppStrings.trackerActionAiInsights =>
                AppRouterGo.push(trackerAiInsightsView, extra: state.extra),
              AppStrings.trackerActionViewAlerts =>
                AppRouterGo.push(trackerNotificationsView),
              AppStrings.trackerGenerateReport =>
                AppRouterGo.push(trackerReportsView),
              AppStrings.trackerSecureShare =>
                AppRouterGo.push(trackerSecureShareView),
              _ => null,
            },
          ),
        ),
      ),
      GoRoute(
        path: trackerTimelineView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackerTimelineView(user: state.extra as TrackerUserEntity?),
        ),
      ),
      GoRoute(
        path: trackerMapPlaybackView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child:
              TrackerMapPlaybackView(user: state.extra as TrackerUserEntity?),
        ),
      ),
      GoRoute(
        path: trackerLiveTrackingView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child:
              TrackerLiveTrackingView(user: state.extra as TrackerUserEntity?),
        ),
      ),
      GoRoute(
        path: trackerCheckInsView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackerCheckInsView(user: state.extra as TrackerUserEntity?),
        ),
      ),
      GoRoute(
        path: trackerCaseDetailView,
        redirect: (context, state) =>
            state.extra is TrackerCaseEntity ? null : trackerDashboardView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackerCaseDetailView(
            caseEntity: state.extra! as TrackerCaseEntity,
          ),
        ),
      ),
      GoRoute(
        path: trackerReportsView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackerReportsView(
            onShareLink: () => AppRouterGo.push(trackerSecureShareView),
          ),
        ),
      ),
      GoRoute(
        path: trackerSecureShareView,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TrackerSecureShareView(),
        ),
      ),
      GoRoute(
        path: trackerNotificationSettingsView,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TrackerNotificationSettingsView(),
        ),
      ),
      GoRoute(
        path: trackerDisplayThemeView,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TrackerDisplayThemeView(),
        ),
      ),
      GoRoute(
        path: trackerSecuritySettingsView,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TrackerSecuritySettingsView(),
        ),
      ),
      GoRoute(
        path: trackerPhoneNumberView,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TrackerPhoneNumberView(),
        ),
      ),
      GoRoute(
        path: trackerEmailSettingsView,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TrackerEmailSettingsView(),
        ),
      ),
      GoRoute(
        path: trackerEditProfileView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackerEditProfileView(
            onSaved: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      GoRoute(
        path: trackerPlanSubscriptionView,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TrackerPlanSubscriptionView(),
        ),
      ),
      GoRoute(
        path: trackerHelpSupportView,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TrackerHelpSupportView(),
        ),
      ),
      GoRoute(
        path: trackerAiInsightsView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackerAiInsightsView(user: state.extra as TrackerUserEntity?),
        ),
      ),
      GoRoute(
        path: trackerLogDetailView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackerLogDetailView(
            onSecurityDetails: () => AppRouterGo.push(
                trackerSecurityDetailsView,
                extra: state.extra),
            onViewOnMap: () =>
                AppRouterGo.push(trackerMapPlaybackView, extra: state.extra),
          ),
        ),
      ),
      GoRoute(
        path: trackerNotificationsView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackerNotificationsView(
            onAlertSelected: (_) => AppRouterGo.push(trackerLogDetailView),
          ),
        ),
      ),
      GoRoute(
        path: trackerDashboardView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackerDashboardView(),
        ),
      ),
      GoRoute(
        path: viewerSignInView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: ViewerSignInView(
            onSignIn: (email) =>
                AppRouterGo.pushRemoveUntil(trackerDashboardView),
            onBiometrics: () =>
                AppRouterGo.pushRemoveUntil(trackerDashboardView),
            onForgotPassword: () => AppRouterGo.push(viewerForgotPasswordView),
            onRegister: () => AppRouterGo.push(viewerRegisterView),
          ),
        ),
      ),
      GoRoute(
        path: viewerForgotPasswordView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: ViewerForgotPasswordView(
            onContinue: (email) => AppRouterGo.push(
              viewerVerifyView,
              extra: {'email': email, 'flow': 'reset'},
            ),
          ),
        ),
      ),
      GoRoute(
        path: viewerRegisterView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: ViewerRegisterView(
            onRegister: (email) => AppRouterGo.push(
              viewerVerifyView,
              extra: {'email': email, 'flow': 'register'},
            ),
          ),
        ),
      ),
      GoRoute(
        path: viewerVerifyView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: Builder(
            builder: (context) {
              final extra = (state.extra as Map?) ?? const {};
              final isReset = extra['flow'] == 'reset';
              return ViewerVerifyView(
                email: (extra['email'] as String?) ?? '',
                // Reset → set a new password; register → 2FA, then the
                // shared plan / subscription screens.
                onVerified: () => isReset
                    ? AppRouterGo.push(viewerNewPasswordView)
                    : AppRouterGo.push(twoFactorView),
              );
            },
          ),
        ),
      ),
      GoRoute(
        path: viewerNewPasswordView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: ViewerNewPasswordView(
            // Back to viewer sign in once the password is saved.
            onSaved: () => AppRouterGo.pushRemoveUntil(viewerSignInView),
          ),
        ),
      ),
      GoRoute(
        path: registerView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: RegisterView(
            onRegister: (email) => AppRouterGo.push(verifyView, extra: email),
          ),
        ),
      ),
      GoRoute(
        path: verifyView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: VerifyView(
            email: (state.extra as String?) ?? '',
            onVerify: (code) => AppRouterGo.push(twoFactorView),
          ),
        ),
      ),
      GoRoute(
        path: twoFactorView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TwoFactorView(
            onVerify: (code) => AppRouterGo.push(trackedChoosePlanView),
          ),
        ),
      ),
      GoRoute(
        path: trackedChoosePlanView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackedChoosePlanView(
            onContinue: () => AppRouterGo.push(trackedConfirmSubscriptionView),
          ),
        ),
      ),
      GoRoute(
        path: trackedConfirmSubscriptionView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackedConfirmSubscriptionView(
            onConfirmed: () =>
                AppRouterGo.pushReplacement(trackedSubscriptionActiveView),
          ),
        ),
      ),
      GoRoute(
        path: trackedSubscriptionActiveView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackedSubscriptionActiveView(
            onGetStarted: () =>
                AppRouterGo.pushRemoveUntil(enableLocationAccessView),
          ),
        ),
      ),
      GoRoute(
        path: enableLocationAccessView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: EnableLocationAccessView(
            onAllow: () => AppRouterGo.pushRemoveUntil(trackedDashboardView),
            onNotNow: () => AppRouterGo.pushRemoveUntil(trackedDashboardView),
          ),
        ),
      ),
      GoRoute(
        path: trackedDashboardView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedDashboardView(),
        ),
      ),
      GoRoute(
        path: trackedSyncStatusView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedSyncStatusView(),
        ),
      ),
      GoRoute(
        path: trackedLogDetailsView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackedLogDetailsView(
            entry: state.extra as TrackedLogEntryEntity?,
          ),
        ),
      ),
      GoRoute(
        path: trackedLogCaptureView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedLogCaptureView(),
        ),
      ),
      GoRoute(
        path: trackedSosView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackedSosView(onActivated: AppRouterGo.back),
        ),
      ),
      GoRoute(
        path: trackedCheckInsView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackedCheckInsView(
            onStart: () => AppRouterGo.push(trackedCheckInVerifyView),
          ),
        ),
      ),
      GoRoute(
        path: trackedCheckInVerifyView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedCheckInVerifyView(),
        ),
      ),
      GoRoute(
        path: trackedSelfieCaptureView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedSelfieCaptureView(),
        ),
      ),
      GoRoute(
        path: trackedCheckInCompleteView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedCheckInCompleteView(),
        ),
      ),
      GoRoute(
        path: trackedCaptureImageView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedCaptureImageView(),
        ),
      ),
      GoRoute(
        path: trackedReviewImageView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedReviewImageView(),
        ),
      ),
      GoRoute(
        path: trackedLiveMapView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: TrackedLiveMapView(
            onLogNow: () => AppRouterGo.push(trackedLogCaptureView),
            onCapture: () => AppRouterGo.push(trackedCaptureImageView),
          ),
        ),
      ),
      GoRoute(
        path: trackedZoneStatusView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedZoneStatusView(),
        ),
      ),
      GoRoute(
        path: trackedAddNoteView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedAddNoteView(),
        ),
      ),
      GoRoute(
        path: trackedExportCenterView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedExportCenterView(),
        ),
      ),
      GoRoute(
        path: trackedAntiSpoofingView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedAntiSpoofingView(),
        ),
      ),
      GoRoute(
        path: trackedMembershipView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedMembershipView(),
        ),
      ),
      GoRoute(
        path: trackedEditProfileView,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TrackedEditProfileView(),
        ),
      ),
    ],
  );

  static void back() {
    if (context.canPop()) {
      context.pop();
    }
  }

  static void push(location, {Object? extra, Function(dynamic)? onThen}) {
    context.push(location, extra: extra).then((value) {
      onThen?.call(value);
    });
  }

  static pushRemoveUntil(location) {
    context.go(location);
  }

  static pushReplacement(location, {Object? extra}) {
    context.replace(location, extra: extra);
  }
}
