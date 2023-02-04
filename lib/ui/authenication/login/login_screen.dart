import 'package:bebeautyapp/repo/function/sign_in.dart';
import 'package:bebeautyapp/ui/admin/home_admin.dart';
import 'package:bebeautyapp/ui/authenication/register/register_screen.dart';
import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../home_page.dart';
import 'forgot_password_screen.dart';
import 'package:provider/provider.dart';
import 'widgets/login_with_button.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final signInFunctions = SignIn_Function();
  final loginButtonController = RoundedLoadingButtonController();
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/image_bg_login.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 140,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          focusNode: emailFocusNode,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          cursorColor: Colors.white,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Email is empty';
                            } else if (!emailValidatorRegExp.hasMatch(text)) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          controller: Provider.of<SignIn_Function>(context,
                                  listen: false)
                              .emailController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          obscureText: _obscureText,
                          onChanged: (value) {
                            password = value;
                          },
                          style: const TextStyle(color: Colors.white),
                          focusNode: passwordFocusNode,
                          controller: Provider.of<SignIn_Function>(context,
                                  listen: false)
                              .passwordController,
                          cursorColor: Colors.white,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Password is empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                            ),
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        "Forgot password?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 0.5,
                          color: Colors.white,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ),
                  ),
                  CustomRoundedLoadingButton(
                    text: 'Sign in',
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        int result = await signInFunctions
                            .logInWithEmailAndPassword(email, password);
                        if (result == 0) {
                          // sign in as admin
                          // Open Home Page for admin
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Logged in successfully.'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Future.delayed(const Duration(milliseconds: 500), () {
                            setState(() {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeAdmin()),
                                  (route) => false);
                            });
                          });
                          loginButtonController.success();
                        } else if (result == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Logged in successfully.'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          loginButtonController.success();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            setState(() {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                  (route) => false);
                            });
                          });
                        } else {
                          loginButtonController.stop();
                        }
                        loginButtonController.stop();
                      } else {
                        loginButtonController.stop();
                      }
                    },
                    controller: loginButtonController,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Don’t have an account? ',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          fontFamily: 'Helvetica',
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                //register click
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()),
                                );
                              },
                            text: 'Register now',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: kRedColor,
                              letterSpacing: 0.5,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 24,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
