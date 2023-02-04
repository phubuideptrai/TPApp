import 'package:bebeautyapp/constants.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

import '../../authenication/login/login_screen.dart';
import '../../authenication/register/register_screen.dart';

class WelcomeView extends StatelessWidget {
  final AnimationController animationController;
  const WelcomeView({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget image_slider_carousel = Container(
      height: 360,
      width: double.infinity,
      child: Carousel(
        boxFit: BoxFit.cover,
        dotSize: 6.0,
        dotSpacing: 15.0,
        dotPosition: DotPosition.bottomCenter,
        images: const [
          AssetImage("assets/images/introduction_bg.png"),
          AssetImage("assets/images/intro_background.png"),
        ],
      ),
    );

    final _firstHalfAnimation =
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final _secondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.8,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _welcomeFirstHalfAnimation =
        Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    return SlideTransition(
      position: _firstHalfAnimation,
      child: SlideTransition(
        position: _secondHalfAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
                position: _welcomeFirstHalfAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 250,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 24.0),
                      child: Text.rich(TextSpan(
                          text: 'Welcome to\n',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Laila',
                              color: kTextColor,
                              fontWeight: FontWeight.w500),
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'The world of\n',
                              style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Laila',
                                  color: kTextColor),
                            ),
                            TextSpan(
                              text: 'LaMuse',
                              style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Laila',
                                  color: kRedColor),
                            )
                          ])),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 32,
                            height: 48,
                            child: OutlinedButton(
                              child: const Text('Login',
                                  style: TextStyle(
                                      color: kGreenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: kGreenColor,
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, RegisterScreen.id);
                          },
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
