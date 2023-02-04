import 'package:flutter/material.dart';
import '../../../constants.dart';

class DefaultBackButton extends StatelessWidget {
  const DefaultBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        "assets/icons/back.png",
        height: 24,
        width: 24,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
