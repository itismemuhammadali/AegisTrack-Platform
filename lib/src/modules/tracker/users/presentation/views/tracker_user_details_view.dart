import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';

/// Read-only overview. Metrics and history are the Figma sample data until
/// the assigned-user detail API is connected.
class TrackerUserDetailsView extends StatelessWidget {
  const TrackerUserDetailsView(
      {super.key, required this.user, this.onAction, this.onSecurityDetails});
  final TrackerUserEntity user;
  final VoidCallback? onSecurityDetails;
  final ValueChanged<String>? onAction;

  static const _actions = [
    ('Timeline', 'timeline'),
    ('Map Playback', 'map'),
    ('Live View', 'live'),
    ('Check-ins', 'check_ins'),
    ('AI Insights', 'ai'),
    ('View Alerts', 'alerts'),
  ];

  @override
  Widget build(BuildContext context) {
    final status = user.isSos
        ? 'SOS'
        : user.isOnline
            ? 'Online'
            : 'Offline';
    final initials = user.name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0])
        .join();
    final info = [
      ('Last Location', user.location.replaceFirst('Last: ', '')),
      (
        'Last Log',
        user.name == 'Daniel Chen'
            ? '2 min ago'
            : user.lastSeen.split('•').last.trim()
      ),
      ('Last Sync', '14:32 today'),
      ('Connection', user.isOnline ? 'Online' : 'Offline'),
      ('Active Alerts', '2'),
      ('Missed Check-ins', '1'),
      ('Zone Events', '3 today'),
      ('Security Flags', '0'),
    ];
    return Scaffold(
      backgroundColor: AppColors.trackedDashboardBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, .5, 1],
          colors: [
            AppColors.onboardingScrimNavy.withValues(alpha: .4),
            AppColors.onboardingScrimNavy.withValues(alpha: .9),
            AppColors.onboardingScrimNavy.withValues(alpha: .4),
          ],
        )),
        child: SafeArea(
            child: Column(children: [
          Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                    width: 40.w,
                    height: 40.w,
                    child: IconButton(
                      tooltip: 'Back to users',
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: .05),
                          shape: RoundedRectangleBorder(
                              borderRadius: 18.circular,
                              side: BorderSide(
                                  color: Colors.white.withValues(alpha: .1)))),
                      icon: const _DetailIcon('back', size: 20),
                    )),
                16.pw,
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _DetailText(user.name,
                          size: 24, weight: FontWeight.w600, height: 32 / 24),
                      4.ph,
                      const _DetailText('User Overview',
                          size: 12, color: Colors.white, height: 16 / 12),
                    ])),
              ])),
          Expanded(
              child: ListView(
            key: const PageStorageKey('tracker-user-details'),
            padding: AppInsets.only(left: 24, right: 24, top: 24, bottom: 24),
            children: [
              _DetailSurface(
                  child: Row(children: [
                Container(
                    width: 64.w,
                    height: 64.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xff321f67).withValues(alpha: .4),
                              const Color(0xff5b3a9e).withValues(alpha: .4)
                            ])),
                    child: _DetailText(initials,
                        size: 20, weight: FontWeight.w700)),
                16.pw,
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _DetailText(user.name, size: 20, weight: FontWeight.w600),
                      4.ph,
                      TrackerBadge(status,
                          color: user.isSos
                              ? AppColors.trackerSosRed
                              : user.isOnline
                                  ? AppColors.trackerOnlineGreen
                                  : Colors.white60),
                      4.ph,
                      const _DetailText('Authorized Access · Read-Only',
                          size: 12, color: Colors.white60),
                    ])),
              ])),
              24.ph,
              for (var i = 0; i < info.length; i += 2) ...[
                IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      Expanded(
                          child:
                              _InfoTile(label: info[i].$1, value: info[i].$2)),
                      8.pw,
                      Expanded(
                          child: _InfoTile(
                              label: info[i + 1].$1, value: info[i + 1].$2)),
                    ])),
                10.ph,
              ],
              const _InfoTile(label: 'Authenticity Trend', value: '↑ Stable'),
              24.ph,
              _DetailSurface(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Row(children: [
                      Expanded(
                          child: _DetailText('Authenticity Score',
                              weight: FontWeight.w600)),
                      TrackerBadge('Verified',
                          color: AppColors.trackerOnlineGreen, horizontal: 16)
                    ]),
                    10.ph,
                    Row(children: [
                      const _DetailText('94',
                          size: 32,
                          weight: FontWeight.w700,
                          color: AppColors.trackerOnlineGreen),
                      10.pw,
                      const _DetailText('/ 100',
                          weight: FontWeight.w600, color: Colors.white60)
                    ]),
                    10.ph,
                    const _DetailText(
                        'All security checks passed. GPS authentic.',
                        size: 12,
                        color: Colors.white60),
                    10.ph,
                    _DetailButton('View Security Details',
                        onTap: onSecurityDetails),
                  ])),
              24.ph,
              const _DetailText('Quick Actions', weight: FontWeight.w600),
              10.ph,
              for (var i = 0; i < _actions.length; i += 2) ...[
                IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      for (var j = i; j < i + 2; j++) ...[
                        if (j > i) 10.pw,
                        Expanded(
                            child: InkWell(
                          borderRadius: 16.circular,
                          onTap: onAction == null
                              ? null
                              : () => onAction!(_actions[j].$1),
                          child: _DetailSurface(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Row(children: [
                                  Container(
                                      width: 32.w,
                                      height: 32.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: .05),
                                          borderRadius: 16.circular),
                                      child: _DetailIcon(_actions[j].$2)),
                                  const Spacer(),
                                  if (j == 4)
                                    const _SmallBadge('EXPERT',
                                        color: Color(0x4d5b3a9e)),
                                  if (j == 5)
                                    const _SmallBadge('2',
                                        color: Color(0xfffb2c36)),
                                ]),
                                8.ph,
                                _DetailText(_actions[j].$1,
                                    weight: FontWeight.w600),
                              ])),
                        )),
                      ],
                    ])),
                if (i < 4) 10.ph,
              ],
              24.ph,
              const _DetailText('Recent Activity', weight: FontWeight.w600),
              10.ph,
              _DetailSurface(
                  padding: 0,
                  child: Column(children: [
                    _ActivityRow(
                        time: '14:32',
                        label: 'Check-in',
                        location: user.location.replaceFirst('Last: ', ''),
                        color: AppColors.trackerOnlineGreen),
                    Divider(
                        height: 1, color: Colors.white.withValues(alpha: .05)),
                    const _ActivityRow(
                        time: '13:15',
                        label: 'Zone Entry',
                        location: 'Permitted Zone',
                        color: Color(0xff51a2ff)),
                    Divider(
                        height: 1, color: Colors.white.withValues(alpha: .05)),
                    const _ActivityRow(
                        time: '09:10',
                        label: 'Started',
                        location: 'Session begun',
                        color: Colors.white60),
                  ])),
              24.ph,
              _DetailSurface(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const _DetailText('Security Flags',
                        weight: FontWeight.w600),
                    10.ph,
                    Row(children: [
                      Container(
                          width: 32.w,
                          height: 32.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xff00c950)
                                  .withValues(alpha: .2)),
                          child: const _DetailIcon('security')),
                      10.pw,
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const _DetailText('No security flags',
                                weight: FontWeight.w500),
                            4.ph,
                            const _DetailText('All checks passed',
                                size: 12, color: Colors.white60)
                          ])),
                    ]),
                  ])),
              24.ph,
              _DetailSurface(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const _DetailText('Zone Events Today',
                        weight: FontWeight.w600),
                    for (final (time, title) in [
                      ('09:15', 'Entered: Permitted Zone'),
                      ('17:30', 'Exited: Permitted Zone')
                    ]) ...[
                      10.ph,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DetailText(time, size: 12, color: Colors.white60),
                            12.pw,
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  _DetailText(title, weight: FontWeight.w600),
                                  const _DetailText('Office Building',
                                      size: 12, color: Colors.white60)
                                ])),
                          ]),
                    ],
                  ])),
              24.ph,
              Row(children: [
                Expanded(
                    child: _DetailButton('Generate Report',
                        icon: 'report',
                        onTap: onAction == null
                            ? null
                            : () => onAction!('Generate Report'))),
                24.pw,
                Expanded(
                    child: _DetailButton('Secure Share',
                        icon: 'share',
                        primary: true,
                        onTap: onAction == null
                            ? null
                            : () => onAction!('Secure Share'))),
              ]),
            ],
          )),
        ])),
      ),
    );
  }
}

class _DetailText extends StatelessWidget {
  const _DetailText(this.text,
      {this.size = 14,
      this.weight = FontWeight.w400,
      this.color = AppColors.viewerSignInText,
      this.height});
  final String text;
  final double size;
  final FontWeight weight;
  final Color color;
  final double? height;
  @override
  Widget build(BuildContext context) => Text(text,
      style: context.bodyMediumStyle?.copyWith(
          fontSize: size.sp,
          fontWeight: weight,
          color: color,
          height: height ?? 1.2));
}

class _DetailIcon extends StatelessWidget {
  const _DetailIcon(this.name, {this.size = 16});
  final String name;
  final double size;
  @override
  Widget build(BuildContext context) =>
      SvgPicture.asset('assets/icons/svg/tracker_user_detail_$name.svg',
          width: size.w, height: size.w);
}

class _DetailSurface extends StatelessWidget {
  const _DetailSurface({required this.child, this.padding = 16});
  final Widget child;
  final double padding;
  @override
  Widget build(BuildContext context) => TrackerSurface(
      padding: padding,
      borderColor: Colors.white.withValues(alpha: .05),
      child: child);
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints(minHeight: 66.h),
        padding: AppInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .05),
            borderRadius: 20.circular),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _DetailText(label, size: 12, color: Colors.white60),
          10.ph,
          // Long locations retain the design's single line at narrow widths.
          FittedBox(
              fit: BoxFit.scaleDown,
              child: _DetailText(value, weight: FontWeight.w600)),
        ]),
      );
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge(this.label, {required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
      padding: AppInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: 100.circular),
      child: _DetailText(label,
          size: label == '2' ? 12 : 10, weight: FontWeight.w500));
}

class _DetailButton extends StatelessWidget {
  const _DetailButton(this.label,
      {this.icon, this.primary = false, this.onTap});
  final String label;
  final String? icon;
  final bool primary;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      borderRadius: 20.circular,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 46.h),
        padding: AppInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
            color: primary
                ? const Color(0xff321f67)
                : Colors.white.withValues(alpha: .05),
            borderRadius: 20.circular),
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (icon != null) ...[_DetailIcon(icon!), 8.pw],
              _DetailText(label, weight: FontWeight.w500)
            ])),
      ));
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow(
      {required this.time,
      required this.label,
      required this.location,
      required this.color});
  final String time, label, location;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
      padding: AppInsets.all(16),
      child: Row(children: [
        _DetailText(time, size: 12, color: Colors.white60),
        14.pw,
        TrackerBadge(label, color: color),
        14.pw,
        const _DetailIcon('location', size: 12),
        6.pw,
        Expanded(child: _DetailText(location, size: 12, color: Colors.white60)),
        8.pw,
        const _DetailIcon('chevron'),
      ]));
}
