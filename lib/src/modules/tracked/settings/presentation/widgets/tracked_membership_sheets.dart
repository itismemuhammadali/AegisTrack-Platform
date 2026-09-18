import '../../../../../core/utils/app_exports.dart';

/// Bottom-sheet shell shared by the membership sheets (Figma: 24px top
/// radius, 10% white border, navy glass background).
Future<T?> showTrackedMembershipSheet<T>(
  BuildContext context, {
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    barrierColor: AppColors.black50,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: Container(
        width: double.infinity,
        padding: AppInsets.only(left: 24, right: 24, top: 24, bottom: 40),
        decoration: BoxDecoration(
          color: AppColors.trackedMembershipSheetBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(
            color: AppColors.primaryWhite.withValues(alpha: 0.1),
          ),
        ),
        child: SafeArea(top: false, child: child),
      ),
    ),
  );
}

/// Icon + title + subtitle + description + Cancel / Confirm sheet used for
/// downgrade, upgrade and remove-card confirmations.
class TrackedMembershipConfirmSheet extends StatelessWidget {
  const TrackedMembershipConfirmSheet({
    super.key,
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.confirmLabel,
    required this.onConfirm,
    this.confirmGradient,
    this.descriptionColor = AppColors.hintGray,
  });

  final String icon;
  final Color accent;
  final String title;
  final InlineSpan subtitle;
  final String description;
  final String confirmLabel;
  final VoidCallback onConfirm;

  /// When set, replaces the 80% [accent] fill of the confirm button.
  final Gradient? confirmGradient;
  final Color descriptionColor;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = context.bodyMediumStyle?.copyWith(
      fontSize: 14.sp,
      height: 20 / 14,
      color: AppColors.signInDarkSubtitle,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.2),
                borderRadius: 18.circular,
              ),
              child: SvgPicture.asset(icon, width: 20.w, height: 20.w),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.bodyLargeStyle?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      height: 24 / 16,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  Text.rich(TextSpan(style: bodyStyle, children: [subtitle])),
                ],
              ),
            ),
          ],
        ),
        10.ph,
        Text(
          description,
          style: bodyStyle?.copyWith(
            height: 22.75 / 14,
            color: descriptionColor,
          ),
        ),
        34.ph,
        Row(
          children: [
            Expanded(
              child: _SheetButton(
                label: AppStrings.trackedMembershipCancel,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            16.pw,
            Expanded(
              child: _SheetButton(
                label: confirmLabel,
                color: confirmGradient == null
                    ? accent.withValues(alpha: 0.8)
                    : null,
                gradient: confirmGradient,
                onTap: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.onTap,
    this.color,
    this.gradient,
  });

  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Gradient? gradient;

  bool get _isSecondary => color == null && gradient == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isSecondary
              ? AppColors.primaryWhite.withValues(alpha: 0.05)
              : color,
          gradient: gradient,
          borderRadius: 16.circular,
          border: _isSecondary
              ? Border.all(color: AppColors.primaryWhite.withValues(alpha: 0.1))
              : null,
        ),
        child: Text(
          label,
          style: context.bodyMediumStyle?.copyWith(
            fontSize: 14.sp,
            fontWeight: _isSecondary ? FontWeight.w500 : FontWeight.w600,
            height: 20 / 14,
            color: AppColors.primaryWhite,
          ),
        ),
      ),
    );
  }
}

class TrackedAddCardSheet extends HookWidget {
  const TrackedAddCardSheet({super.key, required this.onAdd});

  final void Function(String number, String expiry) onAdd;

  @override
  Widget build(BuildContext context) {
    final number = useTextEditingController();
    final expiry = useTextEditingController();
    final cvc = useTextEditingController();
    useListenable(Listenable.merge([number, expiry, cvc]));

    final digits = number.text.replaceAll(' ', '');
    final isValid = digits.length >= 15 &&
        RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(expiry.text) &&
        cvc.text.length >= 3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.trackedMembershipAddPaymentMethod,
                style: context.titleMediumStyle?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 28 / 18,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 32.w,
                height: 32.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite.withValues(alpha: 0.1),
                  borderRadius: 14.circular,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 16.w,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
          ],
        ),
        16.ph,
        _CardField(
          label: AppStrings.trackedMembershipCardNumber,
          hint: AppStrings.trackedMembershipCardNumberHint,
          controller: number,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _GroupFormatter(groupSize: 4, separator: ' '),
          ],
        ),
        16.ph,
        Row(
          children: [
            Expanded(
              child: _CardField(
                label: AppStrings.trackedMembershipExpiryDate,
                hint: AppStrings.trackedMembershipExpiryHint,
                controller: expiry,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _GroupFormatter(groupSize: 2, separator: '/'),
                ],
              ),
            ),
            10.pw,
            Expanded(
              child: _CardField(
                label: AppStrings.trackedMembershipCvc,
                hint: AppStrings.trackedMembershipCvcHint,
                controller: cvc,
                obscure: true,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
            ),
          ],
        ),
        16.ph,
        GestureDetector(
          onTap: isValid
              ? () {
                  Navigator.of(context).pop();
                  onAdd(digits, expiry.text);
                }
              : null,
          child: Container(
            width: double.infinity,
            padding: AppInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isValid
                  ? null
                  : AppColors.primaryWhite.withValues(alpha: 0.05),
              gradient: isValid
                  ? const LinearGradient(
                      colors: AppColors.trackedQuickActionGradientColors,
                    )
                  : null,
              borderRadius: 16.circular,
            ),
            child: Text(
              AppStrings.trackedConfirmAddCard,
              style: context.bodyMediumStyle?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
                color: isValid ? AppColors.primaryWhite : AppColors.hintGray,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardField extends StatelessWidget {
  const _CardField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.formatters,
    this.obscure = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final List<TextInputFormatter> formatters;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.bodyMediumStyle?.copyWith(
      fontSize: 14.sp,
      color: AppColors.primaryWhite,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.bodySmallStyle?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
            color: AppColors.signInDarkSubtitle,
          ),
        ),
        10.ph,
        Container(
          padding: AppInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite.withValues(alpha: 0.05),
            borderRadius: 18.circular,
            border: Border.all(
              color: AppColors.primaryWhite.withValues(alpha: 0.1),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: formatters,
            obscureText: obscure,
            cursorColor: AppColors.primaryWhite,
            style: textStyle,
            decoration: InputDecoration(
              isDense: true,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: AppInsets.symmetric(vertical: 16),
              hintText: hint,
              hintStyle: textStyle?.copyWith(color: AppColors.hintGray),
            ),
          ),
        ),
      ],
    );
  }
}

/// Inserts [separator] every [groupSize] digits (card number / expiry).
class _GroupFormatter extends TextInputFormatter {
  _GroupFormatter({
    required this.groupSize,
    required this.separator,
  });

  final int groupSize;
  final String separator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text;
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % groupSize == 0) buffer.write(separator);
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
