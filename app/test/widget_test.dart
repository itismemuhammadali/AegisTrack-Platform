import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joshua_r_hughes/src/components/primary_app_button.dart';
import 'package:joshua_r_hughes/src/modules/onboarding/presentation/views/role_selection_view.dart';

void main() {
  testWidgets('RoleSelectionView renders role options and handles selection', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(440, 1500);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var trackedTapped = false;
    var trackerTapped = false;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (context, child) => MaterialApp(
          home: RoleSelectionView(
            onTrackedSelected: () => trackedTapped = true,
            onTrackerSelected: () => trackerTapped = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify header title and cards
    expect(find.text('Choose Your Role'), findsOneWidget);
    expect(find.text('Tracked Individual'), findsOneWidget);
    expect(find.text('Authorized Viewer'), findsOneWidget);

    // Initial role is Tracked Individual -> ensure visible and tap button
    await tester.ensureVisible(find.byType(PrimaryAppButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PrimaryAppButton));
    await tester.pumpAndSettle();
    expect(trackedTapped, isTrue);

    // Now tap Authorized Viewer role
    await tester.ensureVisible(find.text('Authorized Viewer'));
    await tester.tap(find.text('Authorized Viewer'));
    await tester.pumpAndSettle();

    // Ensure visible and tap button again
    await tester.ensureVisible(find.byType(PrimaryAppButton));
    await tester.tap(find.byType(PrimaryAppButton));
    await tester.pumpAndSettle();
    expect(trackerTapped, isTrue);
  });
}
