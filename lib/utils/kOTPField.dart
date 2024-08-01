import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'colors.dart';

class KOtpField extends StatefulWidget {
  final void Function(String)? onCompleted;
  final String? Function(String?)? validator;
  final int length;
  const KOtpField({
    super.key,
    this.onCompleted,
    required this.length,
    this.validator,
  });

  @override
  State<KOtpField> createState() => _KOtpFieldState();
}

class _KOtpFieldState extends State<KOtpField> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: kColor(context).surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: kColor(context).tertiary,
          ),
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
        border: Border(
            bottom: BorderSide(color: kColor(context).tertiary, width: 2)),
        color: Colors.white);

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
          // color: Colors.white,
          // color: kColor(context).tertiaryContainer,
          ),
    );
    return Pinput(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      length: widget.length,
      validator: widget.validator,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: widget.onCompleted,
    );
  }
}
