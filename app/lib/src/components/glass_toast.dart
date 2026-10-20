import '../core/utils/app_exports.dart';

class GlassToast extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const GlassToast({super.key, required this.message, this.isSuccess = true});

  @override
  Widget build(BuildContext context) {
    final Color baseColor =
        isSuccess ? AppColors.primaryGreen : AppColors.eventRed;

    return Container(
      margin: AppInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.55),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.primaryblack.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: AppInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: AppInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? Icons.check_rounded : Icons.close_rounded,
              color: AppColors.primaryWhite,
              size: 20.sp,
            ),
          ),
          12.pw,
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontFamily: 'Roboto', 
                color: AppColors.primaryWhite,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
