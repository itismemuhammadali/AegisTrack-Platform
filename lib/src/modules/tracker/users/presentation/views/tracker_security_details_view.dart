import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';

/// Read-only security report using the supplied Figma sample log results.
class TrackerSecurityDetailsView extends StatelessWidget {
  const TrackerSecurityDetailsView(
      {super.key,
      required this.user,
      this.onViewRelatedLog,
      this.onDownloadReport});
  final TrackerUserEntity user;
  final VoidCallback? onViewRelatedLog;
  final VoidCallback? onDownloadReport;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.onboardingScrimNavy,
        body: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [
                0,
                .5,
                1
              ],
                  colors: [
                const Color(0xff2b2f3f).withValues(alpha: .6),
                const Color(0xff000414).withValues(alpha: .6),
                const Color(0xff2b2f3f).withValues(alpha: .6),
              ])),
          child: SafeArea(
              child: Column(children: [
            Padding(
                padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                child: Row(children: [
                  SizedBox(
                      width: 40.w,
                      height: 40.w,
                      child: IconButton(
                        tooltip: 'Back to user overview',
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        style: IconButton.styleFrom(
                            backgroundColor:
                                Colors.white.withValues(alpha: .05),
                            shape: RoundedRectangleBorder(
                                borderRadius: 18.circular,
                                side: BorderSide(
                                    color:
                                        Colors.white.withValues(alpha: .1)))),
                        icon: SvgPicture.asset(
                            'assets/icons/svg/tracker_user_detail_back.svg',
                            width: 20.w,
                            height: 20.w),
                      )),
                  16.pw,
                  const Expanded(
                      child: _Text('Security Details',
                          size: 24, weight: FontWeight.w600)),
                ])),
            Expanded(
                child: ListView(
              key: const PageStorageKey('tracker-security-details'),
              padding: AppInsets.only(left: 24, right: 24, bottom: 24),
              children: [
                TrackerSurface(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const _Text('94',
                                size: 48,
                                weight: FontWeight.w700,
                                color: AppColors.trackerOnlineGreen,
                                height: 1),
                            8.pw,
                            Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: const _Text('/ 100 · VERIFIED')),
                          ]),
                      14.ph,
                      const _Text('All primary security checks passed',
                          weight: FontWeight.w500),
                      14.ph,
                      const _Text('Log #LG-2024-8821 · 14:32:07 · Dec 12, 2024',
                          size: 12, monospace: true),
                    ])),
                24.ph,
                const _SectionTitle('SECURITY CHECKS'),
                10.ph,
                for (final label in [
                  'Mock Location Detection',
                  'Fake GPS Detection',
                  'Root / Jailbreak Detection',
                  'App Integrity',
                  'Device Integrity'
                ]) ...[
                  _CheckCard(label),
                  10.ph,
                ],
                const _CheckCard('VPN / Network',
                    status: 'FLAGGED',
                    icon: 'flagged',
                    color: Color(0xffff6467),
                    background: Color(0x33fb2c36),
                    description: 'VPN connection detected at time of log'),
                10.ph,
                _Notice(
                    color: const Color(0xfffe9a00),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SecurityIcon('warning', size: 16),
                          8.pw,
                          const Expanded(
                              child: _Text(
                                  'Note: VPN detection does not invalidate the log. Original timestamp and GPS coordinates remain authentic. Authenticity Score reflects this flag.',
                                  size: 12,
                                  color: Color(0xffffd230),
                                  height: 19.5 / 12)),
                        ])),
                10.ph,
                const _CheckCard('Clock Manipulation'),
                10.ph,
                const _CheckCard('Bluetooth Correlation',
                    status: 'NOT AVAILABLE',
                    icon: 'unavailable',
                    color: Colors.white,
                    background: Color(0x1affffff),
                    description: 'Bluetooth disabled'),
                10.ph,
                const _CheckCard('Suspicious Activity',
                    status: 'UNDER REVIEW',
                    icon: 'review',
                    color: Color(0xff51a2ff),
                    background: Color(0x332b7fff),
                    description: 'Pattern analysis in progress'),
                24.ph,
                const _SectionTitle('DEVICE INFORMATION'),
                10.ph,
                TrackerSurface(
                    child: Column(children: [
                  for (final (label, value) in [
                    ('Device Model', 'iPhone 14 Pro'),
                    ('OS', 'iOS 17.2.1'),
                    ('App Version', '3.4.2 (Build 441)'),
                    ('Device ID', '••••7f3a')
                  ]) ...[
                    if (label != 'Device Model') 10.ph,
                    _DeviceRow(label: label, value: value),
                  ],
                ])),
                24.ph,
                _FooterButton('View Related Log',
                    primary: true, onTap: onViewRelatedLog),
                10.ph,
                _FooterButton('Download Security Report',
                    icon: 'download', onTap: onDownloadReport),
                24.ph,
                _Notice(
                    color: const Color(0xff2b7fff),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 16.w,
                              height: 16.w,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0x332b7fff)),
                              child: const _Text('i',
                                  size: 10,
                                  weight: FontWeight.w700,
                                  color: Color(0xff51a2ff))),
                          8.pw,
                          const Expanded(
                              child: _Text(
                                  'Security details are read-only. You cannot modify security check results or authenticity scores.',
                                  size: 12,
                                  color: Color(0xff8ec5ff),
                                  height: 19.5 / 12)),
                        ])),
              ],
            )),
          ])),
        ),
      );
}

class _Text extends StatelessWidget {
  const _Text(this.text,
      {this.size = 14,
      this.weight = FontWeight.w400,
      this.color = Colors.white,
      this.height = 20 / 14,
      this.monospace = false});
  final String text;
  final double size, height;
  final FontWeight weight;
  final Color color;
  final bool monospace;
  @override
  Widget build(BuildContext context) => Text(text,
      style: context.bodyMediumStyle?.copyWith(
          fontSize: size.sp,
          fontWeight: weight,
          color: color,
          height: height,
          fontFamily: monospace ? 'monospace' : null));
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Text(label,
      style: context.bodySmallStyle?.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 1.2,
          height: 16 / 12));
}

class _SecurityIcon extends StatelessWidget {
  const _SecurityIcon(this.name, {this.size = 12});
  final String name;
  final double size;
  @override
  Widget build(BuildContext context) =>
      SvgPicture.asset('assets/icons/svg/tracker_security_$name.svg',
          width: size.w, height: size.w);
}

class _CheckCard extends StatelessWidget {
  const _CheckCard(this.label,
      {this.status = 'PASSED',
      this.icon = 'passed',
      this.color = AppColors.trackerOnlineGreen,
      this.background = const Color(0x3300c950),
      this.description});
  final String label, status, icon;
  final String? description;
  final Color color, background;
  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .05),
            borderRadius: 20.circular,
            border: Border.all(color: Colors.white.withValues(alpha: .1))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: _Text(label, weight: FontWeight.w500)),
            8.pw,
            Flexible(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        padding:
                            AppInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: background, borderRadius: 100.circular),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          _SecurityIcon(icon),
                          4.pw,
                          Flexible(
                              child: _Text(status,
                                  size: 12,
                                  weight: FontWeight.w500,
                                  color: color,
                                  height: 16 / 12)),
                        ])))),
          ]),
          if (description != null) ...[
            6.ph,
            _Text(description!, size: 12, height: 16 / 12)
          ],
        ]),
      );
}

class _Notice extends StatelessWidget {
  const _Notice({required this.color, required this.child});
  final Color color;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
      padding: AppInsets.all(16),
      decoration: BoxDecoration(
          color: color.withValues(alpha: .07),
          borderRadius: 20.circular,
          border: Border.all(color: color.withValues(alpha: .25))),
      child: child);
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(flex: 2, child: _Text(label, size: 12)),
        8.pw,
        Expanded(flex: 2, child: _Text(value, size: 12, monospace: true)),
        8.pw,
        Flexible(
            flex: 4,
            child: Container(
              padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: const Color(0x1afe9a00),
                  borderRadius: 16.circular,
                  border: Border.all(color: const Color(0x4dfe9a00))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const _SecurityIcon('locked'),
                6.pw,
                const Flexible(
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: _Text('LOCKED · IMMUTABLE',
                            size: 12,
                            color: AppColors.trackerAmber,
                            weight: FontWeight.w500,
                            height: 16 / 12)))
              ]),
            )),
      ]);
}

class _FooterButton extends StatelessWidget {
  const _FooterButton(this.label,
      {this.primary = false, this.icon, this.onTap});
  final String label;
  final bool primary;
  final String? icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      borderRadius: 16.circular,
      child: Container(
        padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: primary ? const Color(0xff321f67) : null,
            borderRadius: 16.circular,
            border: primary
                ? null
                : Border.all(color: Colors.white.withValues(alpha: .1))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null) ...[_SecurityIcon(icon!, size: 16), 8.pw],
          Flexible(
              child: _Text(label,
                  size: 16, weight: FontWeight.w600, height: 24 / 16))
        ]),
      ));
}
