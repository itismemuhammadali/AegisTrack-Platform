import 'package:flutter/material.dart';
import 'package:joshua_r_hughes/src/modules/tracker/users/presentation/views/tracker_security_details_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:joshua_r_hughes/src/modules/tracker/dashboard/presentation/views/tracker_dashboard_view.dart';
import 'package:joshua_r_hughes/src/modules/tracker/home/presentation/widgets/tracker_user_card.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:joshua_r_hughes/src/core/handlers/auth_handler.dart';
import 'package:joshua_r_hughes/src/core/services/local_db_service/secure_storage.dart';
import 'package:joshua_r_hughes/src/core/services/registry_service/di.dart';
import 'package:joshua_r_hughes/src/core/services/routing_service/app_routes.dart';
import 'package:joshua_r_hughes/src/core/services/routing_service/named_routes.dart';
import 'package:joshua_r_hughes/src/modules/tracked/authentication/presentation/views/sign_in_options_view.dart';

import 'package:joshua_r_hughes/src/modules/tracker/users/presentation/views/tracker_user_details_view.dart';
import 'package:joshua_r_hughes/src/modules/tracker/home/domain/entities/tracker_user_entity.dart';
import 'package:joshua_r_hughes/src/modules/tracker/users/presentation/views/tracker_live_tracking_view.dart';
import 'package:joshua_r_hughes/src/modules/tracker/users/presentation/views/tracker_map_playback_view.dart';
import 'package:joshua_r_hughes/src/modules/tracker/users/presentation/views/tracker_timeline_view.dart';
import 'package:joshua_r_hughes/src/modules/tracker/users/presentation/widgets/tracker_timeline_log_card.dart';

Future<void> pumpDashboard(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(ProviderScope(
      child: ScreenUtilInit(
    designSize: const Size(440, 956),
    minTextAdapt: true,
    builder: (_, child) => MaterialApp(
        theme: ThemeData.dark(), home: const TrackerDashboardView()),
  )));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Users combines status filters with name and location search',
      (tester) async {
    await pumpDashboard(tester, const Size(440, 956));
    await tester.tap(find.text('Users'));
    await tester.pumpAndSettle();
    expect(find.text('Daniel Chen'), findsOneWidget);
    await tester.tap(find.text('Offline').first);
    await tester.pumpAndSettle();
    expect(find.byType(TrackerUserCard), findsNWidgets(2));
    await tester.enterText(find.byType(TextField), 'central park');
    await tester.pumpAndSettle();
    expect(find.text('James Wilson'), findsOneWidget);
    expect(find.byType(TrackerUserCard), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'not a user');
    await tester.pumpAndSettle();
    expect(find.text('No users found'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('SOS').first);
    await tester.pumpAndSettle();
    expect(find.text('Emma Davis'), findsOneWidget);
    expect(find.byType(TrackerUserCard), findsOneWidget);
    await tester.ensureVisible(find.text('Flagged'));
    await tester.tap(find.text('Flagged'));
    await tester.pumpAndSettle();
    expect(find.text('James Wilson'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bottom bar uses distinct selected exports without extra tint',
      (tester) async {
    await pumpDashboard(tester, const Size(440, 956));
    Finder svg(String name) => find.byWidgetPredicate((widget) =>
        widget is SvgPicture &&
        widget.bytesLoader is SvgAssetLoader &&
        (widget.bytesLoader as SvgAssetLoader).assetName.endsWith(name));
    for (final (tab, activeAsset) in [
      ('Users', 'tracker_nav_users_active.svg'),
      ('Cases', 'tracker_nav_cases_active.svg'),
      ('Profile', 'tracker_nav_profile_active_head.svg'),
    ]) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
      expect(svg(activeAsset), findsOneWidget);
      expect(tester.widget<SvgPicture>(svg(activeAsset)).colorFilter, isNull);
    }
    expect(svg('tracker_nav_users.svg'), findsOneWidget);
    expect(svg('tracker_nav_cases.svg'), findsOneWidget);
    expect(svg('tracker_nav_users_active.svg'), findsNothing);
    expect(svg('tracker_nav_cases_active.svg'), findsNothing);
  });

  testWidgets(
      'Logout clears session and returns to sign-in options without back navigation',
      (tester) async {
    FlutterSecureStorage.setMockInitialValues({
      'accessToken': 'test-session',
      'user': '{"id":"viewer","name":"Alex Viewer","email":"alex@example.com"}',
    });
    locator
        .registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
    locator.registerSingleton<Prefs>(Prefs());
    addTearDown(locator.reset);
    await AuthHandler.ref.init();
    AuthHandler.ref.onBoardToken = 'onboarding-session';
    AuthHandler.ref.onBoadEmail = 'alex@example.com';
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    AppRouterGo.appRouter.go(trackerDashboardView);
    await tester.pumpWidget(ProviderScope(
        child: ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      builder: (_, child) => MaterialApp.router(
          theme: ThemeData.dark(), routerConfig: AppRouterGo.appRouter),
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Logout'), 250,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.byType(SignInOptionsView), findsOneWidget);
    expect(find.byType(TrackerDashboardView), findsNothing);
    expect(AppRouterGo.appRouter.canPop(), isFalse);
    expect(await locator<Prefs>().fetchToken(), isNull);
    expect(await locator<Prefs>().read('user'), isNull);
    expect(AuthHandler.ref.user, isNull);
    expect(AuthHandler.ref.acessToken, isNull);
    expect(AuthHandler.ref.onBoardToken, isNull);
    expect(AuthHandler.ref.onBoadEmail, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bottom bar caps the gap on phones with a home indicator',
      (tester) async {
    tester.view.padding = const FakeViewPadding(bottom: 34);
    addTearDown(tester.view.resetPadding);
    await pumpDashboard(tester, const Size(440, 956));
    final labelBottom = tester.getRect(find.text('Profile')).bottom;
    expect(956 - labelBottom, closeTo(12, 0.1));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Every user card opens its own overview and back preserves search',
      (tester) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    AppRouterGo.appRouter.go(trackerDashboardView);
    await tester.pumpWidget(ProviderScope(
        child: ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      builder: (_, child) => MaterialApp.router(
          theme: ThemeData.dark(), routerConfig: AppRouterGo.appRouter),
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Users'));
    await tester.pumpAndSettle();
    for (final name in [
      'Daniel Chen',
      'Aisha Johnson',
      'Sarah Martinez',
      'James Wilson',
      'Emma Davis'
    ]) {
      await tester.enterText(find.byType(TextField), name);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TrackerUserCard));
      await tester.pumpAndSettle();
      final detail = tester
          .widget<TrackerUserDetailsView>(find.byType(TrackerUserDetailsView));
      expect(detail.user.name, name);
      expect(find.text('User Overview'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('View Security Details'), 200);
      await tester.tap(find.text('View Security Details'));
      await tester.pumpAndSettle();
      expect(find.text('Security Details'), findsOneWidget);
      expect(
          tester
              .widget<TrackerSecurityDetailsView>(
                  find.byType(TrackerSecurityDetailsView))
              .user
              .name,
          name);
      await tester.tap(find.byTooltip('Back to user overview'));
      await tester.pumpAndSettle();
      expect(find.byType(TrackerSecurityDetailsView), findsNothing);
      expect(find.text('User Overview'), findsOneWidget);
      await tester.tap(find.byTooltip('Back to users'));
      await tester.pumpAndSettle();
      expect(find.byType(TrackerUserDetailsView), findsNothing);
      expect(find.text(name), findsNWidgets(2));
      expect(find.byType(TrackerUserCard), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  for (final width in [320.0, 440.0]) {
    testWidgets(
        'Security details scrolls through checks and device data at $width',
        (tester) async {
      tester.view.physicalSize = Size(width, 956);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(ScreenUtilInit(
        designSize: const Size(440, 956),
        minTextAdapt: true,
        builder: (_, child) => const ProviderScope(
          child: MaterialApp(
            home: TrackerSecurityDetailsView(
                user: TrackerUserEntity(
              name: 'Daniel Chen',
              lastSeen: 'Today • 3 min ago',
              location: 'Midtown Manhattan, NY',
              authenticity: TrackerAuthenticity.acceptable,
            )),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('94'), findsOneWidget);
      for (final label in [
        'FLAGGED',
        'NOT AVAILABLE',
        'UNDER REVIEW',
        'DEVICE INFORMATION',
        'Download Security Report',
        'Security details are read-only. You cannot modify security check results or authenticity scores.'
      ]) {
        await tester.scrollUntilVisible(find.text(label), 160);
        await tester.pumpAndSettle();
        expect(find.text(label), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('User overview scrolls to its footer at width $width',
        (tester) async {
      tester.view.physicalSize = Size(width, 956);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(ScreenUtilInit(
          designSize: const Size(440, 956),
          minTextAdapt: true,
          builder: (_, child) => const ProviderScope(
                  child: MaterialApp(
                      home: TrackerUserDetailsView(
                          user: TrackerUserEntity(
                name: 'Daniel Chen',
                lastSeen: 'Today • 3 min ago',
                location: 'Midtown Manhattan, NY',
                authenticity: TrackerAuthenticity.acceptable,
              ))))));
      await tester.pumpAndSettle();
      expect(find.text('DC'), findsOneWidget);
      for (final label in [
        'Authenticity Score',
        'Recent Activity',
        'Zone Events Today',
        'Secure Share'
      ]) {
        await tester.scrollUntilVisible(find.text(label), 200);
        await tester.pumpAndSettle();
        expect(find.text(label), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  }

  for (final width in [320.0, 375.0, 440.0]) {
    testWidgets('Viewer tabs render and scroll at width $width',
        (tester) async {
      await pumpDashboard(tester, Size(width, 956));
      for (final tab in ['Users', 'Cases', 'Profile']) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        if (tab == 'Cases') {
          expect(find.text('Martinez Monitoring Case'), findsOneWidget);
        }
        if (tab == 'Profile') {
          expect(find.text('Alex Viewer'), findsOneWidget);
          // The content viewport extends behind the overlaid navigation bar.
          expect(
              tester
                  .getRect(find.byKey(const PageStorageKey('tracker-profile')))
                  .bottom,
              956);
          await tester.scrollUntilVisible(find.text('Logout'), 250,
              scrollable: find.byType(Scrollable).first);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      }
    });
  }

  for (final width in [320.0, 440.0]) {
    testWidgets(
        'Timeline quick action opens the log history and filters it at $width',
        (tester) async {
      tester.view.physicalSize = Size(width, 956);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      AppRouterGo.appRouter.go(trackerDashboardView);
      await tester.pumpWidget(ProviderScope(
          child: ScreenUtilInit(
        designSize: const Size(440, 956),
        minTextAdapt: true,
        builder: (_, child) => MaterialApp.router(
            theme: ThemeData.dark(), routerConfig: AppRouterGo.appRouter),
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Users'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TrackerUserCard).first);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Timeline'), 200);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Timeline'));
      await tester.pumpAndSettle();

      expect(find.byType(TrackerTimelineView), findsOneWidget);
      expect(find.text('Read-only log history'), findsOneWidget);
      expect(find.text('248'), findsOneWidget);
      expect(find.byType(TrackerTimelineLogCard), findsWidgets);
      expect(find.text('TODAY'), findsOneWidget);

      // Every log kind and its footer stay reachable while scrolling.
      for (final label in [
        'CHECK-IN',
        'Entered: Permitted Zone',
        'MISSING / UNKNOWN PERIOD',
        'VPN Detected',
        'OFFLINE',
        'YESTERDAY',
        '93 · VERIFIED',
        'View All on Map'
      ]) {
        await tester.scrollUntilVisible(find.text(label), 160,
            scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        expect(find.text(label), findsOneWidget);
        expect(tester.takeException(), isNull);
      }

      await tester.scrollUntilVisible(find.byType(TextField), -200,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Missing'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Missing'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.byType(TrackerTimelineLogCard), -200,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(find.byType(TrackerTimelineLogCard), findsOneWidget);
      expect(find.text('YESTERDAY'), findsNothing);

      await tester.ensureVisible(find.text('All'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'brooklyn');
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.byType(TrackerTimelineLogCard), -200,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(find.byType(TrackerTimelineLogCard), findsOneWidget);
      expect(find.text('Sarah Martinez'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'nobody');
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('No logs found'), -200,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(find.text('No logs found'), findsOneWidget);
    });
  }

  for (final width in [320.0, 440.0]) {
    testWidgets('Map Playback quick action opens the route playback at $width',
        (tester) async {
      tester.view.physicalSize = Size(width, 956);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      AppRouterGo.appRouter.go(trackerDashboardView);
      await tester.pumpWidget(ProviderScope(
          child: ScreenUtilInit(
        designSize: const Size(440, 956),
        minTextAdapt: true,
        builder: (_, child) => MaterialApp.router(
            theme: ThemeData.dark(), routerConfig: AppRouterGo.appRouter),
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Users'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TrackerUserCard).first);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Map Playback'), 200);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Map Playback'));
      await tester.pumpAndSettle();

      expect(find.byType(TrackerMapPlaybackView), findsOneWidget);
      expect(find.text('Dec 12, 2024'), findsOneWidget);
      expect(find.text('13:15'), findsOneWidget);

      // The speed and range choices are the only controls that hold state.
      await tester.tap(find.text('2x'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Custom Range'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      for (final label in [
        '8h 27m',
        'Filters',
        'Route Timeline',
        'Zone Entry',
        'MISSING INTERVAL BEGIN',
        'MISSING INTERVAL END',
        'Route End'
      ]) {
        await tester.scrollUntilVisible(find.text(label), 160,
            scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        expect(find.text(label), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
      expect(find.text('View Log'), findsWidgets);
    });
  }

  for (final width in [320.0, 440.0]) {
    testWidgets('Live View quick action opens live tracking at $width',
        (tester) async {
      tester.view.physicalSize = Size(width, 956);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      AppRouterGo.appRouter.go(trackerDashboardView);
      await tester.pumpWidget(ProviderScope(
          child: ScreenUtilInit(
        designSize: const Size(440, 956),
        minTextAdapt: true,
        builder: (_, child) => MaterialApp.router(
            theme: ThemeData.dark(), routerConfig: AppRouterGo.appRouter),
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Users'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TrackerUserCard).first);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Live View'), 200);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Live View'));
      await tester.pumpAndSettle();

      expect(find.byType(TrackerLiveTrackingView), findsOneWidget);
      expect(find.text('Daniel Chen'), findsOneWidget);
      expect(find.text('ONLINE'), findsOneWidget);
      expect(find.text('LIVE'), findsOneWidget);
      expect(find.text('LIVE POSITION'), findsOneWidget);
      expect(find.text('Strong'), findsOneWidget);

      // Simulating a dropped signal restates the whole screen.
      await tester.tap(find.text('Simulate Offline'));
      await tester.pumpAndSettle();
      expect(find.text('OFFLINE'), findsOneWidget);
      expect(find.text('LIVE'), findsNothing);
      expect(find.text('LAST KNOWN POSITION'), findsOneWidget);
      expect(find.text('No signal'), findsOneWidget);
      await tester.tap(find.text('Simulate Online'));
      await tester.pumpAndSettle();
      expect(find.text('ONLINE'), findsOneWidget);

      for (final label in [
        'Times Square, Manhattan, NY',
        'LAST CHECK-IN',
        'ACTIVE ZONES',
        'Recent Pings',
        "Hell's Kitchen, Manhattan, NY",
        'Refresh'
      ]) {
        await tester.scrollUntilVisible(find.text(label).first, 160,
            scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        expect(find.text(label), findsWidgets);
        expect(tester.takeException(), isNull);
      }
      await tester.tap(find.text('Refresh'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
