import 'package:client_app/api/api_service.dart';
import 'package:client_app/config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAsyncCallProcess = false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool hidePassword = true;
  bool isRemeber = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ProgressHUD(
          child: Form(
            key: globalKey,
            child: _loginUI(),
          ),
          inAsyncCall: isAsyncCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _loginUI() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Image.asset(
              "assets/images/novation.png",
              fit: BoxFit.contain,
              width: 150,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Client App",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Login",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.deepOrangeAccent,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FormHelper.inputFieldWidget(
            context,
            "Email",
            "E-Mail",
            (onValidate) {
              if (onValidate.isEmpty) {
                return "* Required";
              }
              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(onValidate);

              if (!emailValid) {
                return "Invalid E-mail";
              }

              return null;
            },
            (onSaved) {
              email = onSaved.toString().trim();
            },
            showPrefixIcon: true,
            prefixIcon: Icon(Icons.email_outlined),
            borderRadius: 10,
            contentPadding: 15,
            fontSize: 14,
            prefixIconPaddingLeft: 10,
            borderColor: Colors.grey.shade200,
            prefixIconColor: Colors.black,
            hintFontSize: 14,
            hintColor: Colors.black.withOpacity(.6),
            backgroundColor: Colors.grey.shade100,
            borderFocusColor: Colors.grey.shade200,
          ),
          const SizedBox(
            height: 10,
          ),
          // Update the password input field
          FormHelper.inputFieldWidget(
            context,
            "Password",
            "Password",
            (onValidate) {
              if (onValidate.isEmpty) {
                return "* Required";
              }
              return null;
            },
            (onSaved) {
              password = onSaved.toString().trim();
            },
            showPrefixIcon: true,
            prefixIcon: Icon(Icons.lock_open),
            borderRadius: 10,
            contentPadding: 15,
            fontSize: 14,
            prefixIconPaddingLeft: 10,
            borderColor: Colors.grey.shade200,
            prefixIconColor: Colors.black,
            hintFontSize: 14,
            hintColor: Colors.black.withOpacity(.6),
            backgroundColor: Colors.grey.shade100,
            borderFocusColor: Colors.grey.shade200,
            obscureText: hidePassword, // Add this line
            suffixIcon: IconButton(
              icon: Icon(
                hidePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword; // Toggle password visibility
                });
              },
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          Center(
            child: FormHelper.submitButton(
              "Sign In",
              () {
                if (validataAndSave()) {
                  setState(() {
                    isAsyncCallProcess = true;
                  });
                  APIService.loginUser(email!, password!).then(
                    (res) {
                      setState(() {
                        isAsyncCallProcess = false;
                      });

                      if (res) {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "User Logged-INn Successfully",
                          "ok",
                          () {
                            Navigator.of(context).pop();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "/",
                              (route) => false,
                            );
                          },
                        );
                      } else {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "Invalid Email/Password",
                          "ok",
                          () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    },
                  );
                }
              },
              btnColor: Colors.deepOrangeAccent,
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Dont have an account?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: "Sign Up",
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/register",
                          (route) => false,
                        );
                      },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool validataAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
