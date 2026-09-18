// ignore_for_file: strict_top_level_inference

// This is also known as declerative routing

import '../../../modules/onboarding/presentation/views/onboarding_view.dart';
import '../../../modules/tracked/authentication/presentation/views/enable_location_access_view.dart';
import '../../../modules/tracked/authentication/presentation/views/sign_in_view.dart';
import '../../../modules/tracked/authentication/presentation/views/two_factor_view.dart';
import '../../../modules/tracked/authentication/presentation/views/verify_view.dart';
import '../../../modules/tracked/dashboard/presentation/views/tracked_dashboard_view.dart';
import '../../../modules/tracked/logs/domain/entities/tracked_log_entry_entity.dart';
import '../../../modules/tracked/home/presentation/views/tracked_add_note_view.dart';
import '../../../modules/tracked/home/presentation/views/tracked_log_capture_view.dart';
import '../../../modules/tracked/logs/presentation/views/tracked_log_details_view.dart';
import '../../../modules/tracked/settings/presentation/views/tracked_edit_profile_view.dart';
import '../../../modules/tracked/settings/presentation/views/tracked_export_center_view.dart';
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
            onGetStarted: () => AppRouterGo.push(signInView),
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
