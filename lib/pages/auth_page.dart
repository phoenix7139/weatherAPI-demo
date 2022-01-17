// ignore_for_file: prefer_const_constructors

import 'package:demo_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum authPageState { numberState, otpState }

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var currentState = authPageState.numberState;

  @override
  void initState() {
    currentState = authPageState.numberState;
    super.initState();
  }

  final numberController = TextEditingController();
  final otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showloader = false;

  void signin(PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showloader = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showloader = false;
      });
      if (authCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showloader = false;
      });
      scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("failed"),
        ),
      );
    }
  }

  numberWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          style: TextStyle(color: Colors.white),
          controller: numberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Phone Number",
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () async {
            setState(() {
              showloader = true;
            });
            await _auth.verifyPhoneNumber(
              phoneNumber: "+91" + numberController.text,
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showloader = false;
                });
                // signin(phoneAuthCredential);
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showloader = false;
                });
                scaffoldKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text("failed"),
                  ),
                );
              },
              codeSent: (verificationID, resendingToken) async {
                setState(() {
                  showloader = false;
                  currentState = authPageState.otpState;
                  print(currentState);
                  verificationId = verificationID;
                });
              },
              codeAutoRetrievalTimeout: (verificationID) async {},
            );
          },
          child: Text("Submit"),
        )
      ],
    );
  }

  otpWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          style: TextStyle(color: Colors.white),
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "OTP",
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text);
            signin(phoneAuthCredential);
          },
          child: Text("Submit"),
        )
      ],
    );
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.black),
          padding: EdgeInsets.all(20),
          child: showloader
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == authPageState.numberState
                  ? numberWidget(context)
                  : otpWidget(context),
        ),
      ),
    );
  }
}
