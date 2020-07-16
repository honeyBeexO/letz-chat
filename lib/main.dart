import 'package:chatx/screens/chat_screen.dart';
import 'package:chatx/screens/login_screen.dart';
import 'package:chatx/screens/registration_screen.dart';
import 'package:chatx/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.black54),
          ),
        ),
        //home: WelcomeScreen(),
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomeScreen(),
          //'/login': (context) => LoginScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
        });
  }
}
