import 'package:client_app/api/api_service.dart';
import 'package:client_app/config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool isAsyncCallProcess = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  String? fullName;
  String? companyName;
  String? postalAddress;
  String? password;
  String? confirmPassword;
  String? email;
  String? phoneNumber;
  Country? selectedCountry;

  void showCountryPickerDialog() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ProgressHUD(
          child: Form(
            key: globalKey,
            child: _registerUI(context),
          ),
          inAsyncCall: isAsyncCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _registerUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/novation.png",
                  fit: BoxFit.contain,
                  width: 150,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Client App",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          const Center(
            child: Text(
              "Register",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.deepOrangeAccent,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Full Name
          FormHelper.inputFieldWidget(context, "fullName", "Full Name",
              (onValidateVal) {
            if (onValidateVal.isEmpty) {
              return "* Required";
            }
            return null;
          }, (onSavedVal) {
            fullName = onSavedVal.toString().trim();
          },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.face),
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              prefixIconPaddingLeft: 10,
              borderColor: Colors.grey.shade400,
              textColor: Colors.black,
              prefixIconColor: Colors.black,
              hintColor: Colors.black.withOpacity(.6),
              backgroundColor: Colors.grey.shade100,
              borderFocusColor: Colors.grey.shade200),

 
          const SizedBox(height: 10),
          FormHelper.inputFieldWidget(context, "companyName", "Company Name",
              (onValidateVal) {
            if (onValidateVal.isEmpty) {
              return "* Required";
            }
            return null;
          }, (onSavedVal) {
            companyName = onSavedVal.toString().trim();
          },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.business),
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              prefixIconPaddingLeft: 10,
              borderColor: Colors.grey.shade400,
              textColor: Colors.black,
              prefixIconColor: Colors.black,
              hintColor: Colors.black.withOpacity(.6),
              backgroundColor: Colors.grey.shade100,
              borderFocusColor: Colors.grey.shade200),


          const SizedBox(height: 10),
          Container(
            height: 56, 
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: showCountryPickerDialog,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedCountry != null
                            ? "${selectedCountry!.name} (+${selectedCountry!.phoneCode})"
                            : "Select Country",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),


          const SizedBox(height: 10),
          FormHelper.inputFieldWidget(
            context,
            "phoneNumber",
            "Phone Number",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "* Required";
              }
              return null;
            },
            (onSavedVal) {
              phoneNumber = onSavedVal.toString().trim();
            },
            showPrefixIcon: true,
            prefixIcon: const Icon(Icons.phone),
            borderRadius: 10,
            contentPadding: 15,
            fontSize: 14,
            prefixIconPaddingLeft: 10,
            borderColor: Colors.grey.shade400,
            textColor: Colors.black,
            prefixIconColor: Colors.black,
            hintColor: Colors.black.withOpacity(.6),
            backgroundColor: Colors.grey.shade100,
            borderFocusColor: Colors.grey.shade200,
            
          ),

          const SizedBox(height: 10),

          FormHelper.inputFieldWidget(
              context, "postalAddress", "Postal Address", (onValidateVal) {
            if (onValidateVal.isEmpty) {
              return "* Required";
            }
            return null;
          }, (onSavedVal) {
            postalAddress = onSavedVal.toString().trim();
          },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.location_on),
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              prefixIconPaddingLeft: 10,
              borderColor: Colors.grey.shade400,
              textColor: Colors.black,
              prefixIconColor: Colors.black,
              hintColor: Colors.black.withOpacity(.6),
              backgroundColor: Colors.grey.shade100,
              borderFocusColor: Colors.grey.shade200),

          const SizedBox(height: 10),
          FormHelper.inputFieldWidget(context, "email", "E-mail",
              (onValidateVal) {
            if (onValidateVal.isEmpty) {
              return "* Required";
            }
            bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(onValidateVal);
            if (!emailValid) {
              return "Invalid E-mail";
            }
            return null;
          }, (onSavedVal) {
            email = onSavedVal.toString().trim();
          },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.email_outlined),
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              prefixIconPaddingLeft: 10,
              borderColor: Colors.grey.shade400,
              textColor: Colors.black,
              prefixIconColor: Colors.black,
              hintColor: Colors.black.withOpacity(.6),
              backgroundColor: Colors.grey.shade100,
              borderFocusColor: Colors.grey.shade200),

          // Password
          FormHelper.inputFieldWidget(
            context,
            "password",
            "Password",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "* Required";
              }
              return null;
            },
            (onSavedVal) {
              password = onSavedVal.toString().trim();
            },
            showPrefixIcon: true,
            prefixIcon: const Icon(Icons.password_outlined),
            borderRadius: 10,
            contentPadding: 15,
            fontSize: 14,
            prefixIconPaddingLeft: 10,
            borderColor: Colors.grey.shade400,
            textColor: Colors.black,
            prefixIconColor: Colors.black,
            hintColor: Colors.black.withOpacity(.6),
            backgroundColor: Colors.grey.shade100,
            borderFocusColor: Colors.grey.shade200,
            obscureText: hidePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              color: Colors.black,
              icon: Icon(
                hidePassword ? Icons.visibility_off : Icons.visibility,

              ),
            ),
            onChange: (val) {
              password = val;
            },
          ),

          // Confirm Password
          const SizedBox(height: 10),
          FormHelper.inputFieldWidget(
            context,
            "confirmPassword",
            "Confirm Password",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "* Required";
              }
              if (onValidateVal != password) {
                return "Confirm Password not matched";
              }
              return null;
            },
            (onSavedVal) {
              confirmPassword = onSavedVal.toString().trim();
            },
            showPrefixIcon: true,
            prefixIcon: const Icon(Icons.password_outlined),
            borderRadius: 10,
            contentPadding: 15,
            fontSize: 14,
            prefixIconPaddingLeft: 10,
            borderColor: Colors.grey.shade400,
            textColor: Colors.black,
            prefixIconColor: Colors.black,
            hintColor: Colors.black.withOpacity(.6),
            backgroundColor: Colors.grey.shade100,
            borderFocusColor: Colors.grey.shade200,
            obscureText: hideConfirmPassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hideConfirmPassword = !hideConfirmPassword;
                });
              },
               color: Colors.black,
              icon: Icon(
                hideConfirmPassword ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            onChange: (val) {
              confirmPassword = val;
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: FormHelper.submitButton(
              "Register",
              () {
                if (validateSave()) {
                  setState(() {
                    isAsyncCallProcess = true;
                  });

                  APIService.registerUser(
                    fullName!,
                    email!,
                    password!,
                    companyName!,
                    phoneNumber!,
                    postalAddress!,
                  ).then(
                    (response) {
                      setState(() {
                        isAsyncCallProcess = false;
                      });

                      if (response) {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "Registration  completed successfully",
                          "ok",
                          () {
                            Navigator.of(context).pop();
                          },
                        );
                      } else {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "This email already registered",
                          "ok",
                          () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              "/login",
                              (route) => false,
                            );
                          },
                        );
                      }
                    },
                  );
                }
              },
              btnColor: Colors.deepOrange,
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
                children: <TextSpan>[
                  TextSpan(text: "Already have an account?"),
                  TextSpan(
                    text: "Sign In",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/login",
                          (route) => false,
                        );
                      },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool validateSave() {
    final form = globalKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
