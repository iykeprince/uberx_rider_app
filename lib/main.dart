import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/data_handler/app_data.dart';
import 'package:rider_app/screens/loginscreen.dart';
import 'package:rider_app/screens/mainscreen.dart';
import 'package:rider_app/screens/registrationscreen.dart';

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child('users');
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UberX Rider App',
          theme: ThemeData(
            fontFamily: "Signatra",
            primarySwatch: Colors.blue,
          ),
          initialRoute: FirebaseAuth.instance.currentUser == null
              ? LoginScreen.idScreen
              : MainScreen.idScreen,
          routes: {
            RegistrationScreen.idScreen: (context) => RegistrationScreen(),
            LoginScreen.idScreen: (context) => LoginScreen(),
            MainScreen.idScreen: (context) => MainScreen()
          }),
    );
  }
}
