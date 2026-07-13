import 'package:flutter/cupertino.dart';
import '../core/utils/app_exports.dart';

class PrimaryElevatedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool loader, enabled;
  final Color? backgroundColor, textColor, loaderColor, disableButtonTextColor;
  final double? height, loaderSize;
  final double width;
  final TextStyle? style;
  final num? radius;
  final ButtonStyle? buttonStyle;
  final IconData? trailingIcon;
  final Widget? leadingWidget;

  const PrimaryElevatedButton({
    super.key,
    required this.onTap,
    required this.text,
    this.loader = false,
    this.backgroundColor,
    this.disableButtonTextColor,
    this.textColor,
    this.height,
    this.width = double.infinity,
    this.enabled = true,
    this.style,
    this.radius,
    this.loaderColor,
    this.buttonStyle,
    this.loaderSize,
    this.trailingIcon,
    this.leadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final themedStyle = Theme.of(context).elevatedButtonTheme.style;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Figma: light mode dims the whole button (bg + label) to 60% opacity,
    // dark mode swaps to a solid muted surface with full-opacity label.
    final disabledBackground =
        isDark ? AppColors.travellerBorder : AppColors.signInLightText;
    final disabledOpacity = isDark ? 1.0 : 0.6;

    return Opacity(
      opacity: enabled ? 1.0 : disabledOpacity,
      child: SizedBox(
        width: width,
        height: isPortrait ? height ?? 60.h : 50,
        child: ElevatedButton(
          onPressed: enabled ? (loader ? null : onTap) : null,
          style: buttonStyle ??
              themedStyle?.copyWith(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: radius?.circular ?? 16.circular,
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  enabled
                      ? loader
                          ? loaderColor ?? AppColors.primaryRed
                          : (backgroundColor ?? AppColors.primaryRed)
                      : disabledBackground,
                ),
              ),
          child: loader
              ? SizedBox(
                  width: loaderSize ?? 20.h,
                  height: loaderSize ?? 20.h,
                  child: (Platform.isIOS || Platform.isMacOS)
                      ? CupertinoActivityIndicator(
                          color: textColor ?? AppColors.primaryblack,
                          radius: 10,
                        )
                      : CircularProgressIndicator(
                          strokeWidth: 3.0,
                          color: textColor ?? AppColors.primaryblack,
                          backgroundColor: AppColors.whitesmoke,
                        ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (leadingWidget != null) ...[leadingWidget!, 16.pw],
                    Text(
                      text,
                      style: style ??
                          TextStyle(
                            fontFamily: 'Roboto',
                            color: enabled
                                ? (textColor ?? AppColors.primaryWhite)
                                : (disableButtonTextColor ??
                                    AppColors.primaryWhite),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    if (trailingIcon != null) ...[
                      8.pw,
                      Icon(
                        trailingIcon,
                        size: 14.sp,
                        color: enabled
                            ? (textColor ?? AppColors.primaryWhite)
                            : AppColors.primaryWhite,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
