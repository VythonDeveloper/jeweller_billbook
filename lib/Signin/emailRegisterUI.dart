import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeweller_billbook/Home/home.dart';
import 'package:page_route_transition/page_route_transition.dart';

import '../colors.dart';
import '../services/auth.dart';

class EmailRegisterUI extends StatefulWidget {
  const EmailRegisterUI({Key? key}) : super(key: key);

  @override
  _EmailRegisterUIState createState() => _EmailRegisterUIState();
}

class _EmailRegisterUIState extends State<EmailRegisterUI> {
  final shopNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    shopNameController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }

  createAccount() async {
    if (formKey.currentState!.validate()) {
      //UNFOCUSSING THE TEXTFIELD
      FocusScope.of(context).unfocus();
      setState(() {
        isLoading = true;
      });
      String res = await AuthMethods().registerWithEmailandPassword(
        context,
        emailController.text,
        passwordController.text,
        shopNameController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (res == 'success') {
        Navigator.popUntil(context, (route) => false);
        PageRouteTransition.push(context, HomePage());
      } else {
        print(res);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: primaryAccentColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          top: false,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  color: primaryAccentColor,
                  padding: EdgeInsets.only(top: 50, bottom: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                        ),
                      ),
                      Text(
                        'Register',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      CustomTextField(
                        icon: Icon(Icons.store),
                        label: 'Shop Name',
                        obsecureText: false,
                        textCapitalization: TextCapitalization.sentences,
                        controller: shopNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This Field is required';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        icon: Icon(Icons.email),
                        label: 'Email',
                        obsecureText: false,
                        textCapitalization: TextCapitalization.none,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                                  .hasMatch(value!)
                              ? null
                              : "Provide a valid password";
                        },
                      ),
                      CustomTextField(
                        icon: Icon(Icons.password),
                        label: 'Password',
                        obsecureText: true,
                        textCapitalization: TextCapitalization.none,
                        controller: passwordController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'Password Length must be more than 6 characters';
                          } else if (value.isEmpty) {
                            return 'This Field is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       padding:
                //           EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                //       decoration: BoxDecoration(
                //         color: Colors.grey.shade200,
                //         borderRadius: BorderRadius.only(
                //           bottomLeft: Radius.circular(6),
                //           topLeft: Radius.circular(6),
                //         ),
                //       ),
                //       child: Text(
                //         'Already have an account?',
                //         style: TextStyle(
                //           color: Colors.grey.shade600,
                //           fontWeight: FontWeight.w900,
                //           fontSize: 12,
                //         ),
                //       ),
                //     ),
                //     InkWell(
                //       splashColor: Colors.blue.shade100,
                //       onTap: () {},
                //       child: Container(
                //         padding:
                //             EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                //         decoration: BoxDecoration(
                //           color: primaryColor,
                //           borderRadius: BorderRadius.only(
                //             topRight: Radius.circular(6),
                //             bottomRight: Radius.circular(6),
                //           ),
                //         ),
                //         child: Text(
                //           'Log In',
                //           style: TextStyle(
                //             color: Colors.white,
                //             letterSpacing: 1.6,
                //             fontSize: 12,
                //             fontWeight: FontWeight.w500,
                //             // fontFamily: 'default',
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: MaterialButton(
        onPressed: () {
          if (!isLoading) {
            createAccount();
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: primaryColor,
        elevation: 0,
        highlightElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: isLoading
            ? CircularProgressIndicator()
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Widget CustomTextField(
    {final label,
    obsecureText,
    textCapitalization,
    controller,
    keyboardType,
    validator,
    icon}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      obscureText: obsecureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        prefixIcon: icon,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: validator,
    ),
  );
}
