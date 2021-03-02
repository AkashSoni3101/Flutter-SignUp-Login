import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oyebusy/components/social_icons.dart';
import 'package:oyebusy/providers/auth_provider.dart';
import 'package:oyebusy/screen/home_screen.dart';
import 'package:oyebusy/screen/login_screen.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'signup-screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();
  bool _loading = false;
  bool _visible = false;
  bool _isLoggedIn = false;

  static final FacebookLogin facebookSignIn = new FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }

  _gmailLogin() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      ));
    } catch (err) {
      print(err);
    }
  }

  _gmailLogout() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text(
                        'SIGNUP',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    SvgPicture.asset(
                      "assets/icons/signup.svg",
                      height: size.height * 0.25,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixText: '+91',
                        labelText: '10 digit number',
                        enabledBorder: OutlineInputBorder(),
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.phone),
                        focusedBorder: OutlineInputBorder(),
                        focusColor: Theme.of(context).primaryColor,
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      controller: _phoneNumberController,
                      onChanged: (value) {
                        if (value.length == 10) {
                          setState(() {
                            _validPhoneNumber = true;
                          });
                        } else {
                          setState(() {
                            _validPhoneNumber = false;
                          });
                        }
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: FlatButton(
                              child: _loading
                                  ? LinearProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : Text(
                                      'SignUp',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                              onPressed: () {
                                String number =
                                    '+91${_phoneNumberController.text}';
                                auth.verifyPhone(context, number);
                              },
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    FlatButton(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an Account?',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
                        );
                      },
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: size.height * 0.02),
                      width: size.width * 0.8,
                      child: Row(
                        children: <Widget>[
                          buildDivider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          buildDivider(),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SocialIcon(
                          iconSrc: "assets/icons/facebook.svg",
                          press: () async {
                            final FacebookLoginResult result =
                                await facebookSignIn.logIn(['email']);

                            switch (result.status) {
                              case FacebookLoginStatus.loggedIn:
                                final FacebookAccessToken accessToken =
                                    result.accessToken;
                                print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomeScreen();
                                    },
                                  ),
                                );
                                break;
                              case FacebookLoginStatus.cancelledByUser:
                                print('Login cancelled by the user.');
                                break;
                              case FacebookLoginStatus.error:
                                print(
                                    'Something went wrong with the login process.\n'
                                    'Here\'s the error Facebook gave us: ${result.errorMessage}');
                                break;
                            }
                          },
                        ),
                        SocialIcon(
                          iconSrc: "assets/icons/twitter.svg",
                          press: () {},
                        ),
                        SocialIcon(
                          iconSrc: "assets/icons/google-plus.svg",
                          press: () async {
                            _gmailLogin();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
