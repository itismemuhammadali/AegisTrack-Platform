// ignore_for_file: strict_top_level_inference

// This is also known as declerative routing

import '../../../modules/onboarding/presentation/views/onboarding_view.dart';
import '../../../modules/tracked/authentication/presentation/views/sign_in_view.dart';
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
          child: const SignInView(),
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
