import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/controller/tracker_dashboard_controller.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';

class TrackerProfileView extends ConsumerWidget {
  const TrackerProfileView({super.key, this.onAction, this.onLogout});
  final ValueChanged<String>? onAction;
  final VoidCallback? onLogout;

  static const _icons = [
    'assets/icons/svg/tracker_profile_edit.svg',
    'assets/icons/svg/tracker_profile_viewer_shield.svg',
    'assets/icons/svg/tracker_profile_access_lock.svg',
    'assets/icons/svg/tracker_profile_person.svg',
    'assets/icons/svg/tracker_profile_chevron.svg',
    'assets/icons/svg/tracker_profile_email.svg',
    'assets/icons/svg/tracker_profile_phone.svg',
    'assets/icons/svg/tracker_profile_users.svg',
    'assets/icons/svg/tracker_profile_share_link.svg',
    'assets/icons/svg/tracker_profile_reports.svg',
    'assets/icons/svg/tracker_profile_security.svg',
    'assets/icons/svg/tracker_profile_two_factor.svg',
    'assets/icons/svg/tracker_profile_notifications.svg',
    'assets/icons/svg/tracker_profile_dark_mode.svg',
    'assets/icons/svg/tracker_profile_subscription.svg',
    'assets/icons/svg/tracker_profile_help.svg',
    'assets/icons/svg/tracker_profile_logout.svg',
  ];
  static String _icon(int index) => _icons[index];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget section(String title, List<(String, int, String)> rows) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .6,
                    color: Colors.white60)),
            10.ph,
            TrackerSurface(
                padding: 0,
                borderColor: Colors.white.withValues(alpha: .05),
                child: Column(children: [
                  for (var i = 0; i < rows.length; i++) ...[
                    if (i > 0)
                      Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.white.withValues(alpha: .1)),
                    _ProfileRow(
                        label: rows[i].$1,
                        icon: _icon(rows[i].$2),
                        value: rows[i].$3,
                        onTap: rows[i].$1 == 'Assigned Users'
                            ? () => ref
                                .read(trackerDashboardControllerProvider)
                                .onTabTapped(1)
                            : onAction == null
                                ? null
                                : () => onAction!(rows[i].$1)),
                  ],
                ])),
            24.ph,
          ],
        );
    return ListView(
      key: const PageStorageKey('tracker-profile'),
      padding: AppInsets.all(24),
      children: [
        TrackerSurface(
            padding: 20,
            borderColor: Colors.white.withValues(alpha: .05),
            child: Column(children: [
              Row(children: [
                SizedBox(
                    width: 64.w,
                    height: 64.w,
                    child: Stack(children: [
                      Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xff321f67),
                                    Color(0xff5b3a9e)
                                  ]))),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                              onTap: onAction == null
                                  ? null
                                  : () => onAction!('Edit Profile'),
                              child: Container(
                                  padding: AppInsets.all(4),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff321f67)),
                                  child: SvgPicture.asset(_icon(0),
                                      width: 12.w, height: 12.w)))),
                    ])),
                16.pw,
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Alex Viewer',
                          style: context.titleMediumStyle?.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.viewerSignInText)),
                      4.ph,
                      Text('alex.viewer@securetrack.com',
                          style: context.bodySmallStyle?.copyWith(
                              fontSize: 12.sp,
                              color: Colors.white60,
                              fontWeight: FontWeight.w400)),
                      10.ph,
                      Wrap(spacing: 14.w, runSpacing: 6.h, children: [
                        Container(
                            padding:
                                AppInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .05),
                                borderRadius: 100.circular),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              SvgPicture.asset(_icon(1),
                                  width: 12.w, height: 12.w),
                              4.pw,
                              Text('Authorized Viewer',
                                  style: context.bodySmallStyle?.copyWith(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400))
                            ])),
                        const TrackerBadge('EXPERT',
                            background: Color(0x0dffffff)),
                      ]),
                    ])),
              ]),
              16.ph,
              Divider(height: 1, color: Colors.white.withValues(alpha: .1)),
              16.ph,
              Row(children: [
                for (final (value, label) in [
                  ('12', 'Assigned'),
                  ('248', 'Logs'),
                  ('3', 'Cases')
                ])
                  Expanded(
                      child: Column(children: [
                    Text(value,
                        style: context.titleMediumStyle?.copyWith(
                            fontSize: 18.sp,
                            height: 28 / 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.viewerSignInText)),
                    Text(label,
                        style: context.bodySmallStyle?.copyWith(
                            fontSize: 12.sp,
                            height: 16 / 12,
                            color: Colors.white60,
                            fontWeight: FontWeight.w400)),
                  ]))
              ]),
            ])),
        24.ph,
        TrackerSurface(
            borderColor: Colors.white.withValues(alpha: .05),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SvgPicture.asset(_icon(2), width: 16.w, height: 16.w),
              12.pw,
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Authorized Access · Read-Only',
                        style: context.bodySmallStyle?.copyWith(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                    3.ph,
                    Text(
                        'You can view assigned records only. No edit or delete permissions.',
                        style: context.bodySmallStyle?.copyWith(
                            fontSize: 12.sp,
                            color: Colors.white38,
                            fontWeight: FontWeight.w400)),
                  ])),
            ])),
        24.ph,
        section('Account', [
          ('Edit Profile', 3, ''),
          ('Email Settings', 5, 'alex.viewer@...'),
          ('Phone Number', 6, '+1 •••• 4821')
        ]),
        section('Viewer Access', [
          ('Assigned Users', 7, '12 assigned'),
          ('Active Share Links', 8, '2 active'),
          ('Reports', 9, '')
        ]),
        section('SECURITY', [
          ('Security Settings', 10, ''),
          ('Two-Factor Auth', 11, 'Enabled')
        ]),
        section('Preferences', [
          ('Notification Settings', 12, ''),
          ('Dark Mode', 13, 'Always on')
        ]),
        section('Subscription', [('Plan & Subscription', 14, 'EXPERT')]),
        section('Support', [('Help & Support', 15, '')]),
        GestureDetector(
          onTap: onLogout,
          child: Container(
            padding: AppInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
                color: const Color(0xffd4183d).withValues(alpha: .1),
                borderRadius: 16.circular,
                border: Border.all(
                    color: const Color(0xffd4183d).withValues(alpha: .2))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SvgPicture.asset(_icon(16), width: 16.w, height: 16.w),
              8.pw,
              Text('Logout',
                  style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffd4183d)))
            ]),
          ),
        ),
        24.ph,
        Text('SecureTrack v2.1.0 · Authorized Viewer Portal',
            textAlign: TextAlign.center,
            style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                color: const Color(0xff8ba9a3),
                fontWeight: FontWeight.w400)),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow(
      {required this.label,
      required this.icon,
      required this.value,
      this.onTap});
  final String label, icon, value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
            padding: AppInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              Container(
                  width: 32.w,
                  height: 32.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .05),
                      borderRadius: 16.circular),
                  child: SvgPicture.asset(icon, width: 16.w, height: 16.w)),
              12.pw,
              Expanded(
                  child: Text(label,
                      style: context.bodyMediumStyle?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.viewerSignInText))),
              if (value.isNotEmpty) ...[
                8.pw,
                if (value == 'EXPERT')
                  const TrackerBadge('EXPERT', background: Color(0x0dffffff))
                else
                  Text(value,
                      style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: label == 'Active Share Links'
                              ? const Color(0xffede9fe)
                              : Colors.white60)),
              ],
              8.pw,
              SvgPicture.asset(TrackerProfileView._icon(4),
                  width: 16.w, height: 16.w),
            ])),
      );
}
