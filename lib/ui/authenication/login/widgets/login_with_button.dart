import 'package:flutter/material.dart';

class LoginWithButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color iconColor;
  final bool isOutLine;
  final Color textColor;
  final void Function() onPress;
  const LoginWithButton({
    required this.icon,
    required this.text,
    required this.color,
    required this.isOutLine,
    required this.iconColor,
    required this.textColor,
    required this.onPress,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: iconColor,
        ),
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: isOutLine
                  ? const BorderSide(color: Colors.white)
                  : BorderSide.none),
          minimumSize: const Size(170, 46),
          primary: color,
        ),
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Helvetica',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
