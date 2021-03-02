import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oyebusy/constant.dart';
import 'package:oyebusy/screen/profile.dart';
import 'package:oyebusy/screen/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(),
                      ));
                });
              },
              child: Text('Sign Out'),
            ),
            FlatButton(
              child: RichText(
                text: TextSpan(
                  text: 'Update your',
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: ' profile',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Profile();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
