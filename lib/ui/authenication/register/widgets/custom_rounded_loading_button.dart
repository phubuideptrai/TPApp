import 'package:bebeautyapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CustomRoundedLoadingButton extends StatelessWidget {
  final String text;
  final RoundedLoadingButtonController controller;
  final void Function() onPress;
  const CustomRoundedLoadingButton(
      {Key? key,
      required this.text,
      required this.onPress,
      required this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: RoundedLoadingButton(
        borderRadius: 0,
        controller: controller,
        onPressed: onPress,
        successColor: kPrimaryColor,
        height: 48,
        width: 9999,
        child: Text(
          text,
          style: const TextStyle(
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kGreenColor),
        ),
        color: Colors.white,
      ),
    );
  }
}
