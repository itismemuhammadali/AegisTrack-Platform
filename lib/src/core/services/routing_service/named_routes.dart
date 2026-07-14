// ignore_for_file: strict_top_level_inference

// This is also known as declerative routing

import '../../../modules/onboarding/presentation/views/onboarding_view.dart';
import '../../../modules/tracked/authentication/presentation/views/enable_location_access_view.dart';
import '../../../modules/tracked/authentication/presentation/views/sign_in_view.dart';
import '../../../modules/tracked/authentication/presentation/views/two_factor_view.dart';
import '../../../modules/tracked/authentication/presentation/views/verify_view.dart';
import '../../../modules/tracked/dashboard/presentation/views/tracked_dashboard_view.dart';
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
            onVerify: (code) => AppRouterGo.push(enableLocationAccessView),
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
