import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:joshua_r_hughes/src/modules/tracker/dashboard/presentation/views/tracker_dashboard_view.dart';
import 'package:joshua_r_hughes/src/modules/tracker/home/presentation/widgets/tracker_user_card.dart';

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
          await tester.scrollUntilVisible(find.text('Logout'), 250,
              scrollable: find.byType(Scrollable).first);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      }
    });
  }
}
