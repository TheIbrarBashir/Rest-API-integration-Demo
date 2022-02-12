import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputField extends StatelessWidget {
  final Widget? label;
  final String? helperText;
  final String? hintText;
  final double? height;
  final double? width;
  final TextInputType? keyBoardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final String? initialValue;
  final Widget? icon;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final bool expands;
  final bool autofocus;
  final bool filled;
  final bool autoCorrect;
  final Color? fillColor;
  final TextCapitalization textCapitalization;
  final double? letterSpacing;

  const TextInputField(
      {Key? key,
      this.label,
      this.helperText,
      this.hintText,
      this.keyBoardType,
      this.textInputAction,
      this.controller,
      this.onChanged,
      this.validator,
      this.inputFormatters,
      this.maxLines,
      this.maxLength,
      this.initialValue,
      this.icon,
      this.prefix,
      this.prefixIcon,
      this.suffix,
      this.suffixIcon,
      this.focusNode,
      this.onTap,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.onSaved,
      this.height,
      this.width,
      this.expands = false,
      this.autofocus = false,
      this.textCapitalization = TextCapitalization.none,
      this.filled = false,
      this.fillColor,
      this.autoCorrect = false,
      this.obscureText = false,
      this.letterSpacing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height,
        width: width,
        child: TextFormField(
          keyboardType: keyBoardType,
          textInputAction: textInputAction,
          controller: controller,
          validator: validator,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          focusNode: focusNode,
          onTap: onTap,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          onSaved: onSaved,
          maxLines: maxLines,
          maxLength: maxLength,
          initialValue: initialValue,
          autocorrect: autoCorrect,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          expands: expands,
          autofocus: autofocus,
          cursorHeight: 20.0,
          cursorColor: Colors.black,
          cursorWidth: 1.5,
          style: TextStyle(
              fontFamily: "eurostile",
              color: Colors.black,
              letterSpacing: letterSpacing),
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            helperText: helperText,
            hintText: hintText,
            icon: icon,
            prefix: prefix,
            prefixIcon: prefixIcon,
            suffix: suffix,
            suffixIcon: suffixIcon,
            isDense: true,
            fillColor: fillColor,
            filled: filled,
            hintStyle:
                const TextStyle(fontFamily: "eurostile", color: Colors.grey),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.black)),
            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                borderSide:
                    BorderSide(color: Colors.green.shade500, width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.red.shade800, width: 1.5)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                borderSide:
                    BorderSide(color: Colors.orange.shade300, width: 1.5)),
          ),
        ),
      ),
    );
  }
} // End TextInputField
