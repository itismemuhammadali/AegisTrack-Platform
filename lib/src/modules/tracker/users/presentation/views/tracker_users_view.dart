import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../../../home/presentation/widgets/tracker_home_header.dart';
import '../../../home/presentation/widgets/tracker_user_card.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';

class TrackerUsersView extends StatefulWidget {
  const TrackerUsersView(
      {super.key, this.onUserSelected, this.onNotifications});
  final ValueChanged<TrackerUserEntity>? onUserSelected;
  final VoidCallback? onNotifications;

  @override
  State<TrackerUsersView> createState() => _TrackerUsersViewState();
}

class _TrackerUsersViewState extends State<TrackerUsersView> {
  String _query = '';
  String _filter = 'All';
  static const _filters = ['All', 'Online', 'Offline', 'SOS', 'Flagged'];
  // Figma sample records; replace with assigned users from the viewer API.
  static const _users = [
    TrackerUserEntity(
        name: 'Daniel Chen',
        lastSeen: 'Today • 3 min ago',
        location: 'Midtown Manhattan, NY',
        authenticity: TrackerAuthenticity.acceptable),
    TrackerUserEntity(
        name: 'Aisha Johnson',
        lastSeen: 'Today • 2 min ago',
        location: 'Jersey City, NJ',
        authenticity: TrackerAuthenticity.verified),
    TrackerUserEntity(
        name: 'Sarah Martinez',
        lastSeen: 'Today • 2hrs ago',
        location: 'Last: Downtown LA',
        authenticity: TrackerAuthenticity.acceptable,
        isOnline: false),
    TrackerUserEntity(
        name: 'James Wilson',
        lastSeen: 'Today • 3 min ago',
        location: 'Central Park, NY',
        authenticity: TrackerAuthenticity.questionable,
        isOnline: false),
    TrackerUserEntity(
        name: 'Emma Davis',
        lastSeen: 'Today • 45 min ago',
        location: 'Queens, NY',
        authenticity: TrackerAuthenticity.verified,
        isOnline: false,
        isSos: true),
  ];

  @override
  Widget build(BuildContext context) {
    final users = _users.where((user) {
      final matchesQuery =
          '${user.name} ${user.location}'.toLowerCase().contains(_query);
      final matchesFilter = switch (_filter) {
        'Online' => user.isOnline,
        'Offline' => !user.isOnline && !user.isSos,
        'SOS' => user.isSos,
        'Flagged' => user.authenticity == TrackerAuthenticity.questionable,
        _ => true,
      };
      return matchesQuery && matchesFilter;
    }).toList();
    return ListView(
      key: const PageStorageKey('tracker-users'),
      padding: EdgeInsets.fromLTRB(
          24.w, 24.h, 24.w, 24.h + MediaQuery.paddingOf(context).bottom),
      children: [
        TrackerHomeHeader(
            name: AppStrings.trackedSettingsProfileName,
            onNotifications: widget.onNotifications),
        24.ph,
        const TrackerSectionTitle('Assigned Users', mutedSubtitle: true),
        24.ph,
        TextField(
          onChanged: (value) =>
              setState(() => _query = value.trim().toLowerCase()),
          style: context.bodyMediumStyle?.copyWith(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            hintText: 'Search users or locations...',
            hintStyle: context.bodyMediumStyle?.copyWith(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400),
            isDense: true,
            filled: true,
            fillColor: Colors.white.withValues(alpha: .05),
            contentPadding: AppInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
                borderRadius: 20.circular,
                borderSide:
                    BorderSide(color: Colors.white.withValues(alpha: .05))),
            focusedBorder: OutlineInputBorder(
                borderRadius: 20.circular,
                borderSide: const BorderSide(color: Color(0xff5b3a9e))),
          ),
        ),
        10.ph,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final filter in _filters)
              Padding(
                padding: EdgeInsets.only(right: 14.w),
                child: Semantics(
                    selected: _filter == filter,
                    button: true,
                    child: InkWell(
                      borderRadius: 100.circular,
                      onTap: () => setState(() => _filter = filter),
                      child: Container(
                        padding:
                            AppInsets.symmetric(horizontal: 15, vertical: 7),
                        decoration: BoxDecoration(
                            color: _filter == filter
                                ? const Color(0xff321f67)
                                : Colors.white.withValues(alpha: .05),
                            borderRadius: 100.circular,
                            border: Border.all(
                                color: Colors.white.withValues(
                                    alpha: _filter == filter ? 0 : .05))),
                        child: Text(filter,
                            style: context.bodySmallStyle?.copyWith(
                                fontSize: 12.sp,
                                color: Colors.white.withValues(
                                    alpha: _filter == filter ? 1 : .6),
                                fontWeight: FontWeight.w400)),
                      ),
                    )),
              )
          ]),
        ),
        24.ph,
        if (users.isEmpty)
          Padding(
              padding: AppInsets.all(24),
              child: Text('No users found',
                  textAlign: TextAlign.center,
                  style: context.bodyMediumStyle
                      ?.copyWith(color: Colors.white60))),
        for (final user in users)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: GestureDetector(
                onTap: widget.onUserSelected == null
                    ? null
                    : () => widget.onUserSelected!(user),
                child: TrackerUserCard(user: user, compact: true)),
          ),
      ],
    );
  }
}
