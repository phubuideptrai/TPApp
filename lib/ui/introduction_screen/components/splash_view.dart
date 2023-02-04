import 'dart:ui';

import 'package:bebeautyapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashView extends StatefulWidget {
  final AnimationController animationController;

  const SplashView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    final _introductionanimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0.0, -1.0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
        position: _introductionanimation,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/intro_background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 140.0),
                    child: Text(
                      "Be You.\nBe Authentic.\nBe Beauty.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 48.0,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Berfilem",
                          letterSpacing: 0.25,
                          color: kFourthColor),
                    ),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  InkWell(
                    onTap: () {
                      widget.animationController.animateTo(0.2);
                    },
                    child: Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width - 32,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        color: Colors.white,
                        child: Row(
                          children: [
                            const Text(
                              "Let's begin",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Helvetica',
                                color: kTextColor,
                              ),
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              "assets/icons/arrow_next.svg",
                              height: 16,
                              width: 16,
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
