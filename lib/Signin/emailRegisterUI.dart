import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeweller_stockbook/Home/home.dart';
import 'package:jeweller_stockbook/Helper/auth.dart';
import 'package:page_route_transition/page_route_transition.dart';
import '../colors.dart';

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
                  padding: EdgeInsets.only(top: 50, bottom: 10, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Register',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
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
          borderRadius: BorderRadius.circular(isLoading ? 100 : 10),
        ),
        color: primaryColor,
        elevation: 0,
        highlightElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: isLoading
            ? Transform.scale(
                scale: 0.5,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
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
                      fontSize: 15,
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
        border: UnderlineInputBorder(),
      ),
      validator: validator,
    ),
  );
}
