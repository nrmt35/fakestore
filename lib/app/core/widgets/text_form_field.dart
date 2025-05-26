import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.textAlign = TextAlign.start,
    this.obscuringCharacter = '•',
    this.obscureText,
    this.maxLines = 1,
    this.minLines,
    this.maxLength = 50,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.style,
    this.readOnly,
    this.autofocus = false,
    this.initialValue,
    this.focusNode,
    this.hintText,
    this.onTapSuffix,
  });

  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final String obscuringCharacter;
  final bool? obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final bool? readOnly;
  final bool autofocus;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? hintText;
  final VoidCallback? onTapSuffix;

  @override
  Widget build(BuildContext context) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        readOnly: readOnly ?? false,
        cursorColor: context.themeC.buttonBackground,
        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          errorMaxLines: 2,
          contentPadding: const EdgeInsets.all(18),
          filled: true,
          fillColor: context.themeC.inputField,
          hintText: hintText,
          hintStyle: context.themeC.textStyle.copyWith(
            color: context.themeC.hint,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          errorStyle: context.themeC.textStyle.copyWith(
            color: context.themeC.red,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.themeC.red),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.themeC.divider),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.themeC.red),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.themeC.divider),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.themeC.divider),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: context.themeC.divider),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          alignLabelWithHint: true,
          suffixIcon: obscureText != null ? IconButton(
            onPressed: onTapSuffix,
            icon: Icon(
              obscureText ?? false
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: context.themeC.hint,
              size: 22,
            ),
          ) : null,
        ),
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        textAlign: textAlign,
        obscuringCharacter: obscuringCharacter,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onFieldSubmitted,
        onSaved: onSaved,
        validator: validator,
        inputFormatters: inputFormatters,
        style: style ??
            context.themeC.textStyle.copyWith(
              fontSize: 16,
              color: context.themeC.textPrimary,
              fontWeight: FontWeight.w500,
            ),
      );
}
