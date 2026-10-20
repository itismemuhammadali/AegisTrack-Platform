import 'dart:async';
import '../core/utils/app_exports.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget with AppSize {
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLength;
  bool isObscure;
  final bool isPrefix;
  final bool isSuffix;
  final Widget? suffixbutton;
  final int? minLines;
  final TextInputType textInputType;
  final TextAlign textAlign;
  final String? suffixIcon;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool focus;
  final bool? enabled;
  final OutlineInputBorder? inputBorder;
  void Function(String)? onFieldSubmitted;
  final bool enableInteractiveSelection;
  final bool removeSpacing;
  final Color? fillColor;
  final Widget? prefixWidget;
  final TextStyle? hintTextStyle;
  final Color? enableBorderColor;
  final TextCapitalization textCapitalization;
  final bool isLast;
  final TextStyle? textStyle;
  final Color? focusedBorderColor;
  final Color? cursorColor;
  final EdgeInsetsGeometry? contentPadding;
  final double? fieldBorderRadius;
  final double? borderWidth;
  final List<TextInputFormatter>? inputFormatters;

  CustomTextField({
    super.key,
    this.onFieldSubmitted,
    this.controller,
    this.hintText,
    this.isObscure = false,
    this.isSuffix = false,
    this.isPrefix = false,
    this.textInputType = TextInputType.text,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.focus = false,
    this.onChanged,
    this.validator,
    this.inputBorder,
    this.maxLength,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.onEditingComplete,
    this.enabled,
    this.enableInteractiveSelection = true,
    this.removeSpacing = false,
    this.fillColor,
    this.prefixWidget,
    this.hintTextStyle,
    this.enableBorderColor,
    this.textCapitalization = TextCapitalization.none,
    this.suffixbutton,
    this.minLines,
    this.isLast = false,
    this.textStyle,
    this.focusedBorderColor,
    this.cursorColor,
    this.contentPadding,
    this.fieldBorderRadius,
    this.borderWidth,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    if (widget.removeSpacing) {
      widget.controller?.addListener(removeSpaces);
    }
  }

  void removeSpaces() {
    String? text = widget.controller?.text;
    if (text!.contains(' ')) {
      // Cancel any previous timer to avoid multiple triggers
      _timer?.cancel();

      // Start a new timer with a brief delay
      _timer = Timer(const Duration(milliseconds: 500), () {
        // Remove spaces and update text
        widget.controller?.text = text.replaceAll(' ', '');
        // Move cursor to the end of the text
        widget.controller?.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller!.text.length),
        );
      });
    }
  }

  @override
  void dispose() {
    if (widget.removeSpacing) {
      widget.controller?.removeListener(removeSpaces);
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputTheme = Theme.of(context).inputDecorationTheme;

    OutlineInputBorder themedBorder(Color color) {
      return OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: widget.borderWidth ?? 1.088,
        ),
        borderRadius: BorderRadius.circular(
          (widget.fieldBorderRadius ?? 16).r,
        ),
      );
    }

    return TextFormField(
      minLines: widget.minLines,
      inputFormatters: widget.inputFormatters,
      enableInteractiveSelection: widget
          .enableInteractiveSelection, // For copy & Paste OPtion Enable and Disable
      contextMenuBuilder: widget.enableInteractiveSelection
          ? (context, editableTextState) {
              return AdaptiveTextSelectionToolbar.editableText(
                editableTextState: editableTextState,
              );
            }
          : (context, editableTextState) {
              return const SizedBox.shrink();
            },
      onFieldSubmitted: widget.onFieldSubmitted,
      textCapitalization: widget.textCapitalization,
      enabled: widget.enabled,
      textInputAction:
          widget.isLast ? TextInputAction.done : TextInputAction.next,
      onTap: widget.onTap,
      onChanged: widget.onChanged,

      onEditingComplete: widget.onEditingComplete,
      keyboardType: widget.textInputType,
      enableSuggestions: false,
      focusNode: widget.focusNode,
      autocorrect: false,
      readOnly: widget.readOnly,
      controller: widget.controller,
      textAlign: widget.textAlign,
      maxLength: widget.maxLength,
      cursorColor: widget.cursorColor ?? AppColors.primaryRed,
      style: widget.textStyle ??
          context.labelLargeStyle?.copyWith(fontWeight: FontWeight.normal),
      obscureText: widget.isObscure,
      maxLines: widget.maxLines,

      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        // errorMaxLines: 6,
        prefixIcon: widget.isPrefix
            ? Padding(
                padding: AppInsets.only(right: 10, left: 16),
                child: widget.prefixWidget,
              )
            : null,
        prefixIconConstraints: widget.isPrefix
            ? const BoxConstraints(minWidth: 0, minHeight: 0)
            : null,
        isDense: true,
        counterText: "",
        filled: true,
        suffixIcon: widget.isSuffix
            ? IconButton(
                splashRadius: 25.r,
                onPressed: () {
                  setState(() {
                    widget.isObscure = !widget.isObscure;
                  });
                },
                icon: widget.suffixIcon == null
                    ? Icon(
                        !widget.isObscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: widget.isMobile ? 18 : 24,
                      )
                    : SvgPicture.asset(widget.suffixIcon!),
              )
            : widget.suffixbutton,
        fillColor: widget.fillColor ?? inputTheme.fillColor,
        contentPadding: widget.contentPadding ??
            inputTheme.contentPadding ??
            AppInsets.symmetric(horizontal: 16, vertical: 20),
        enabledBorder: widget.focus
            ? themedBorder(AppColors.primaryRed)
            : widget.enableBorderColor != null
                ? themedBorder(widget.enableBorderColor!)
                : inputTheme.enabledBorder,
        focusedBorder: widget.focusedBorderColor != null
            ? themedBorder(widget.focusedBorderColor!)
            : inputTheme.focusedBorder,
        errorBorder: widget.inputBorder ??
            (widget.borderWidth != null || widget.fieldBorderRadius != null
                ? themedBorder(AppColors.primaryRed)
                : inputTheme.errorBorder),
        border: widget.inputBorder ??
            (widget.enableBorderColor != null
                ? themedBorder(widget.enableBorderColor!)
                : inputTheme.border),
        hintText: widget.hintText ?? '',
        hintStyle: widget.hintTextStyle ??
            inputTheme.hintStyle ??
            context.labelSmallStyle?.copyWith(fontWeight: FontWeight.normal),
      ),
    );
  }
}
