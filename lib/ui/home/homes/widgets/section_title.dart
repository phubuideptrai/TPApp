import 'package:bebeautyapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
    required this.color,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/flower.svg',
          color: color,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: press,
          child: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              "See More",
              style: TextStyle(color: kTextLightColor),
            ),
          ),
        ),
      ],
    );
  }
}
