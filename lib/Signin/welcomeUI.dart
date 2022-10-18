import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Login/emailLoginUI.dart';
import 'package:jeweller_stockbook/Signin/emailRegisterUI.dart';
import 'package:jeweller_stockbook/colors.dart';
import 'package:page_route_transition/page_route_transition.dart';

import '../Helper/auth.dart';
import '../Helper/sdp.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: _isLoading
              ? Loading()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Text(
                                  'STOCK',
                                  style: TextStyle(
                                    fontSize: sdp(context, 80),
                                    fontWeight: FontWeight.bold,
                                    color: primaryAccentColor,
                                  ),
                                ),
                                Text(
                                  'Book',
                                  style: TextStyle(
                                    fontSize: sdp(context, 40),
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Made with ❤ for Stock Lovers',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                fontSize: sdp(context, 10),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login Safely with',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            fontSize: sdp(context, 10),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: () async {
                            setState(() => _isLoading = true);
                            String res =
                                await AuthMethods().signInWithgoogle(context);
                            if (res == 'fail') {
                              setState(() => _isLoading = false);
                            }
                          },
                          color: Colors.grey.shade100,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Image.asset(
                              'lib/assets/icons/google.png',
                              height: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'OR Login with',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            fontSize: sdp(context, 10),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: () {
                            PageRouteTransition.push(context, EmailLoginUI());
                          },
                          color: Colors.grey.shade100,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Icon(Icons.email),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Email / Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Don\'t have an Account?',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                PageRouteTransition.push(
                                    context, EmailRegisterUI());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Center Loading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 0.5,
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Fetching Your Stocks',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
