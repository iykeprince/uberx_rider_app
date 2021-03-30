import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/main.dart';
import 'package:rider_app/screens/mainscreen.dart';
import 'package:rider_app/screens/registrationscreen.dart';
import 'package:rider_app/widgets/progress_dialog.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  LoginScreen({Key key}) : super(key: key);

  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 35.0),
          Image(
            image: AssetImage('assets/images/logo.png'),
            width: 390.0,
            height: 250.0,
            alignment: Alignment.center,
          ),
          SizedBox(height: 65.0),
          Text("Login as a Rider",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold")),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 1.0),
                TextField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 1.0),
                TextField(
                  controller: passwordTextEditingController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 1.0),
                ElevatedButton(
                  onPressed: () {
                    if (!emailTextEditingController.text.contains("@")) {
                      displayToastMessage(
                          context, "Email address is not valid");
                    } else if (passwordTextEditingController.text.length < 6) {
                      displayToastMessage(
                          context, "Password must be atleast 6 characters");
                    } else {
                      loginAndAuthenticateUser(context);
                    }
                  },
                  child: Container(
                    color: Colors.yellow,
                    child: Center(
                      child: Text(
                        "Login",
                        style:
                            TextStyle(fontSize: 18, fontFamily: "Brand Bold"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RegistrationScreen.idScreen,
                (route) => false,
              );
            },
            child: Text("Do not have an Account? Register Here."),
          ),
        ],
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(context) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return ProgressDialog(message: "Authenticating, Please wait...");
      },
    );
    final User user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    )
            .catchError((errMsg) {
          Navigator.pop(context);
      displayToastMessage(context, "Error: " + errMsg.toString());
    }))
        .user;

    if (user != null) {
      userRef.child(user.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage(context, "you are logged-in now");
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage(context,
              "No record exists for this user. please create an account");
        }
      });
    } else {
      //error occured - display error
      Navigator.pop(context);
      displayToastMessage(context, "New user account has not been created");
    }
  }
}
