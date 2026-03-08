import 'package:flutter/material.dart';
import '../../helper/constant_app.dart';
import '../../helper/size_app.dart';
import '../../helper/style_app.dart';

class GetInputFromUserWidget extends StatelessWidget {
  const GetInputFromUserWidget({
    super.key,
    required this.controller,
    required this.size,
    this.lableText,
    this.hintText,
    this.keyboardType,
    this.suffixIcon,
    this.isPassword,
    this.onChanged,
    required this.isRequired,
    this.errorText,
    this.requiredText,
    this.errorColor,
    this.isMap,
    this.closeKeyboardOnTapOutside = true,
    this.isCard,
    this.readOnly,
    this.focusNode,
  });

  final TextEditingController controller;
  final SizeApp size;
  final String? lableText;
  final String? hintText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool? isPassword;
  final Function(String)? onChanged;
  final bool isRequired;
  final String? errorText;
  final String? requiredText;
  final Color? errorColor;
  final bool? isMap;
  final bool closeKeyboardOnTapOutside;
  final bool? isCard;
  final bool? readOnly;
  final FocusNode? focusNode;

  double _getFontSize() {
    // قاعدة لتحديد حجم الخط حسب الشاشة
    double baseFont = size.width / 40; // الحساب الأساسي
    if (baseFont < 14) return 14; // أقل حجم
    if (baseFont > 20) return 20; // أقصى حجم
    return baseFont;
  }

  @override
  Widget build(BuildContext context) {
    final bool isReadOnly = readOnly ?? false;

    final double fontSize = _getFontSize();

    Widget textField = TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      focusNode: focusNode,
      obscureText: isPassword ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      onChanged: onChanged ?? (_) {},

      style: StyleApp(height: size.height, width: size.width).mainTextStyle
          .copyWith(
            color: isReadOnly ? Colors.grey : Colors.black,
            fontSize: fontSize,
          ),

      decoration: InputDecoration(
        labelText: lableText,
        hintText: hintText,
        labelStyle: StyleApp(
          height: size.height,
          width: size.width,
        ).mainTextStyle.copyWith(color: Colors.grey, fontSize: fontSize),
        hintStyle: StyleApp(
          height: size.height,
          width: size.width,
        ).mainTextStyle.copyWith(color: Colors.grey, fontSize: fontSize),
        suffixIcon:
            suffixIcon ??
            Icon(
              Icons.input,
              size: fontSize,
              color: isReadOnly ? Colors.grey : ConstantApp.primaryColor,
            ),
        filled: true,
        fillColor: isReadOnly ? Colors.grey.shade100 : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: ConstantApp.primaryColor,
            width: 2,
          ),
        ),

        errorStyle: StyleApp(height: size.height, width: size.width)
            .mainTextStyle
            .copyWith(color: errorColor ?? Colors.red, fontSize: fontSize),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),

      validator: (value) {
        if (!isRequired) return null;

        if (value == null || value.trim().isEmpty) {
          return requiredText ?? errorText;
        }

        if (isCard == true && value.length != 12) {
          return errorText != null && errorText!.isNotEmpty
              ? errorText
              : 'رقم الكرت يجب أن يكون من 12 أرقام';
        }

        if (isPassword == true && value.length < 8) {
          return errorText != null && errorText!.isNotEmpty
              ? errorText
              : 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
        }

        if (isMap == true) {
          final mapRegex = RegExp(
            r'^https:\/\/maps\.app\.goo\.gl\/[a-zA-Z0-9]+$',
          );
          if (!mapRegex.hasMatch(value.trim())) return errorText;
        }

        if (keyboardType == TextInputType.phone) {
          final phoneRegex = RegExp(r'^\+?\d{9,15}$');
          if (!phoneRegex.hasMatch(value.trim())) return errorText;
        }

        if (keyboardType == TextInputType.emailAddress) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value.trim())) {
            return errorText != null && errorText!.isNotEmpty
                ? errorText
                : 'البريد الإلكتروني غير صالح';
          }
        }

        return null;
      },
    );

    if (closeKeyboardOnTapOutside) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: textField,
      );
    }

    return textField;
  }
}
