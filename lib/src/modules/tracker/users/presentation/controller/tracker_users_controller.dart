import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';

class TrackerUsersController extends ChangeNotifier with Buffers {
  static const List<String> filters = [
    AppStrings.trackerFilterAll,
    AppStrings.trackerOnline,
    AppStrings.trackerOffline,
    AppStrings.trackerSos,
    AppStrings.trackerFilterFlagged,
  ];

  // Figma sample records; replace with assigned users from the viewer API.
  final List<TrackerUserEntity> users = const [
    TrackerUserEntity(
      name: 'Daniel Chen',
      lastSeen: 'Today • 3 min ago',
      location: 'Midtown Manhattan, NY',
      authenticity: TrackerAuthenticity.acceptable,
    ),
    TrackerUserEntity(
      name: 'Aisha Johnson',
      lastSeen: 'Today • 2 min ago',
      location: 'Jersey City, NJ',
      authenticity: TrackerAuthenticity.verified,
    ),
    TrackerUserEntity(
      name: 'Sarah Martinez',
      lastSeen: 'Today • 2hrs ago',
      location: 'Last: Downtown LA',
      authenticity: TrackerAuthenticity.acceptable,
      isOnline: false,
    ),
    TrackerUserEntity(
      name: 'James Wilson',
      lastSeen: 'Today • 3 min ago',
      location: 'Central Park, NY',
      authenticity: TrackerAuthenticity.questionable,
      isOnline: false,
    ),
    TrackerUserEntity(
      name: 'Emma Davis',
      lastSeen: 'Today • 45 min ago',
      location: 'Queens, NY',
      authenticity: TrackerAuthenticity.verified,
      isOnline: false,
      isSos: true,
    ),
  ];

  String query = '';
  String filter = AppStrings.trackerFilterAll;

  List<TrackerUserEntity> get visibleUsers => users.where((user) {
        final matchesQuery =
            '${user.name} ${user.location}'.toLowerCase().contains(query);
        final matchesFilter = switch (filter) {
          AppStrings.trackerOnline => user.isOnline,
          AppStrings.trackerOffline => !user.isOnline && !user.isSos,
          AppStrings.trackerSos => user.isSos,
          AppStrings.trackerFilterFlagged =>
            user.authenticity == TrackerAuthenticity.questionable,
          _ => true,
        };
        return matchesQuery && matchesFilter;
      }).toList();

  void setQuery(String value) {
    query = value.trim().toLowerCase();
    notifyListeners();
  }

  void setFilter(String value) {
    filter = value;
    notifyListeners();
  }
}

final trackerUsersControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerUsersController>(
  (ref) => TrackerUsersController(),
);
