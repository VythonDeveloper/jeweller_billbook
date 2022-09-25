import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeweller_billbook/Home/home.dart';
import 'package:jeweller_billbook/Services/auth.dart';
import 'package:page_route_transition/page_route_transition.dart';
import '../colors.dart';
import '../components.dart';

class EmailLoginUI extends StatefulWidget {
  const EmailLoginUI({Key? key}) : super(key: key);

  @override
  _EmailLoginUIState createState() => _EmailLoginUIState();
}

class _EmailLoginUIState extends State<EmailLoginUI> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  logIn() async {
    if (formKey.currentState!.validate()) {
      //UNFOCUSSING THE TEXTFIELD
      FocusScope.of(context).unfocus();

      setState(() {
        isLoading = true;
      });
      String res = await AuthMethods().emailLogInUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() {
        isLoading = false;
      });

      if (res == 'Success') {
        Navigator.popUntil(context, (route) => false);
        PageRouteTransition.push(context, HomePage());
        showSnackBar(context, res);
      } else {
        showSnackBar(context, res);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body: Container(
        child: SafeArea(
          top: false,
          child: Form(
            key: formKey,
            child: Column(
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
                        'Log In',
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
                    CustomTextField(
                      icon: Icon(Icons.email),
                      label: 'Email',
                      obsecureText: false,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This is required';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      icon: Icon(Icons.password),
                      label: 'Password',
                      obsecureText: true,
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                      controller: passwordController,
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Password strength must be more than 6';
                        } else if (value.isEmpty) {
                          return 'This is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: MaterialButton(
        onPressed: () {
          if (!isLoading) {
            logIn();
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
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Log In',
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
}
