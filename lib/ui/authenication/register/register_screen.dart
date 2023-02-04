import 'package:bebeautyapp/repo/function/sign_up.dart';
import 'package:bebeautyapp/ui/authenication/login/login_screen.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'RegisterScreen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String displayName = "";
  String phone = "";
  String password = "";
  String rePassword = "";

  bool checkTerm = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return kRedColor;
    }
    return Colors.white;
  }

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final retypePasswordFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final nameFocusNode = FocusNode();

  final signUpFunctions = SignUp_Function();

  final registerButtonController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/image_bg_login.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              focusNode: emailFocusNode,
                              onChanged: (value) {
                                email = value;
                              },
                              cursorColor: Colors.white,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Email is empty';
                                } else if (!emailValidatorRegExp
                                    .hasMatch(text)) {
                                  return 'Invalid email!';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              controller: Provider.of<SignUp_Function>(context,
                                      listen: false)
                                  .emailController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              focusNode: nameFocusNode,
                              onChanged: (value) {
                                displayName = value;
                              },
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Name is empty';
                                } else if (!kNameRegex.hasMatch(text)) {
                                  return 'Invalid Name!';
                                }
                                return null;
                              },
                              controller: Provider.of<SignUp_Function>(context,
                                      listen: false)
                                  .displayNameController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                labelText: 'Display name',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              focusNode: phoneNumberFocusNode,
                              onChanged: (value) {
                                phone = value;
                              },
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Phone number is empty';
                                } else if (!kPhoneNumber.hasMatch(text)) {
                                  return 'Invalid Phone Number!';
                                }
                                return null;
                              },
                              controller: Provider.of<SignUp_Function>(context,
                                      listen: false)
                                  .phoneNumberController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: _obscureText1,
                              onChanged: (value) {
                                password = value;
                              },
                              focusNode: passwordFocusNode,
                              controller: Provider.of<SignUp_Function>(context,
                                      listen: false)
                                  .passwordController,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Password is empty';
                                } else if (!kPasswordRegex.hasMatch(text)) {
                                  return 'Minimum six characters, at least one uppercase letter,\n '
                                      'one lowercase letter, one number and one special character!';
                                }
                                return null;
                              },
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText1
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText1 = !_obscureText1;
                                    });
                                  },
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: _obscureText2,
                              onChanged: (value) {
                                rePassword = value;
                              },
                              focusNode: retypePasswordFocusNode,
                              controller: Provider.of<SignUp_Function>(context,
                                      listen: false)
                                  .retypePasswordController,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Re-Password is empty';
                                } else if (text != password) {
                                  return 'Password does not match!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText2
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText2 = !_obscureText2;
                                    });
                                  },
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                labelText: 'Re-Password',
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FormField<bool>(
                                  builder: (state) {
                                    return Column(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Checkbox(
                                                fillColor: MaterialStateProperty
                                                    .resolveWith(getColor),
                                                checkColor: kRedColor,
                                                activeColor: kRedColor,
                                                value: checkTerm,
                                                onChanged: (value) {
                                                  setState(() {
                                                    checkTerm = value!;
                                                    state.didChange(value);
                                                  });
                                                }),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text.rich(TextSpan(
                                                  text:
                                                      'By clicking Sign Up, you agree to\nour ',
                                                  style: const TextStyle(
                                                      fontFamily: 'Helvatica',
                                                      fontSize: 12,
                                                      color: Colors.white70),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            'Terms of Service',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: kRedColor,
                                                          fontFamily:
                                                              'Helvatica',
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {}),
                                                    TextSpan(
                                                        text: ' and ',
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'Helvatica',
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white70),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  'Privacy\nPolicy',
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Helvatica',
                                                                  fontSize: 14,
                                                                  color:
                                                                      kRedColor,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline),
                                                              recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {})
                                                        ]),
                                                    const TextSpan(
                                                        text: '.',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Helvatica',
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white70))
                                                  ])),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 110, top: 7),
                                          child: Text(
                                            state.errorText ?? '',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor,
                                                fontSize: 10,
                                                fontFamily: 'Helvatica'),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  validator: (value) {
                                    if (!checkTerm) {
                                      return 'You need to accept Terms & Privacy';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),

                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    bool result =
                                        await signUpFunctions.createUser(email,
                                            displayName, phone, password);
                                    if (result == true) {
                                      Provider.of<SignUp_Function>(context,
                                              listen: false)
                                          .emailController
                                          .clear();
                                      Provider.of<SignUp_Function>(context,
                                              listen: false)
                                          .displayNameController
                                          .clear();
                                      Provider.of<SignUp_Function>(context,
                                              listen: false)
                                          .phoneNumberController
                                          .clear();
                                      Provider.of<SignUp_Function>(context,
                                              listen: false)
                                          .passwordController
                                          .clear();
                                      Provider.of<SignUp_Function>(context,
                                              listen: false)
                                          .retypePasswordController
                                          .clear();
                                      Navigator.pop(context);
                                      registerButtonController.stop();
                                    }
                                  } else {
                                    registerButtonController.stop();
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
                            // Center(
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(bottom: 15),
                            //     child: RichText(
                            //       text: TextSpan(
                            //           text: 'Already have an account? ',
                            //           style: const TextStyle(
                            //             fontSize: 15,
                            //             color: Colors.white70,
                            //             fontFamily: 'Helvatica',
                            //           ),
                            //           children: [
                            //             TextSpan(
                            //               recognizer: TapGestureRecognizer()
                            //                 ..onTap = () {
                            //                   Navigator.push(
                            //                     context,
                            //                     MaterialPageRoute(
                            //                         builder: (context) =>
                            //                             const LoginScreen()),
                            //                   );
                            //                 },
                            //               text: 'Sign In',
                            //               style: const TextStyle(
                            //                 fontSize: 15,
                            //                 color: kRedColor,
                            //                 fontFamily: 'Helvatica',
                            //                 decoration:
                            //                     TextDecoration.underline,
                            //               ),
                            //             ),
                            //           ]),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
