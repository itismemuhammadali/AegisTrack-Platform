import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';

/// [TrackerSurface] with the softer border used on the detail screens.
class TrackerDetailSurface extends StatelessWidget {
  const TrackerDetailSurface(
      {super.key, required this.child, this.padding = 16});

  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) => TrackerSurface(
        padding: padding,
        borderColor: AppColors.trackerSurfaceFill,
        child: child,
      );
}
