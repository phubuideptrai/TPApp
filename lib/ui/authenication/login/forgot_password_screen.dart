import 'package:bebeautyapp/repo/function/forgotPassword.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = "ForgotPasswordScreen";

  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final sendEmailButtonController = RoundedLoadingButtonController();
  final emailFocusNode = FocusNode();
  final emailController = TextEditingController();

  String email = "";
  final forgotPasswordFunctions = ForgotPasswordFunction();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/image_bg_forgot_password.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                      //   ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontFamily: 'Helvetica',
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 50, right: 50, top: 12),
                  child: Text(
                    "don’t worry! it happens. please enter the email address associated with your account.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                      fontFamily: 'Helvetica',
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    focusNode: emailFocusNode,
                    onChanged: (value) {
                      email = value;
                    },
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Email is empty';
                      } else if (!emailValidatorRegExp.hasMatch(text)) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 220,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await forgotPasswordFunctions
                            .sendEmailResetPassword(email);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 32.0),
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
