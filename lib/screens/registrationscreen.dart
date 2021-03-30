import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/screens/mainscreen.dart';

import 'package:rider_app/main.dart';
import 'package:rider_app/widgets/progress_dialog.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";

  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
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
                TextFormField(
                  controller: nameTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 1.0),
                TextFormField(
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
                TextFormField(
                  controller: phoneTextEditingController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 1.0),
                TextFormField(
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
                    if (nameTextEditingController.text.length < 3) {
                      displayToastMessage(
                          context, "name must be atleast 3 characters");
                    } else if (!emailTextEditingController.text.contains("@")) {
                      displayToastMessage(
                          context, "Email address is not valid");
                    } else if (phoneTextEditingController.text.isEmpty) {
                      displayToastMessage(context, "Phone Number is mandatory");
                    } else if (passwordTextEditingController.text.length < 6) {
                      displayToastMessage(
                          context, "Password must be atleast 6 characters");
                    } else {
                      registerNewUser(context);
                    }
                  },
                  child: Container(
                    color: Colors.yellow,
                    child: Center(
                      child: Text(
                        "Create Account",
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
              print('clicked');
            },
            child: Text("Already have an account? Login Here."),
          ),
        ],
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  registerNewUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return ProgressDialog(message: "Registering, Please wait...");
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
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim()
      };

      userRef.child(user.uid).set(userDataMap);
      displayToastMessage(
          context, "Congratulations, your account has been created.");

      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      //error occured - display error
      Navigator.pop(context);
      displayToastMessage(context, "New user account has not been created");
    }
  }
}

displayToastMessage(BuildContext context, String message) {
  Fluttertoast.showToast(msg: message);
}
