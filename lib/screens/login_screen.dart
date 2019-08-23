import 'package:flash_chat/screens/round_button_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'chat_screen.dart';
class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _inProgress = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email, password;
  void loginUser() async{
    setState(() {
      _inProgress = true;
    });
      var currentUser = FirebaseAuth.instance.currentUser();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(currentUser != null){
        _inProgress = false;
        Navigator.pushNamed(context, ChatScreen.id);
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _inProgress,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: kTextBlack,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kTextFieldInputDecoration.copyWith(hintText: 'Enter Your Email')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: kTextBlack,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                  decoration: kTextFieldInputDecoration.copyWith(hintText: 'Enter Your Password')
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundButton(buttonText: 'Log In', buttonColor: Colors.blueAccent, onPressed: (){
                loginUser();
              })
            ],
          ),
        ),
      ),
    );
  }
}
