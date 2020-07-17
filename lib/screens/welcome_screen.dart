import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatx/components/rounded_button.dart';
import 'package:chatx/screens/login_screen.dart';
import 'package:chatx/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

//mixin countFrames {}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin /*countFrames*/ {
  AnimationController controller;
  Animation animation;
  int frame = 1;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(seconds: 1), vsync: this);
    //animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = ColorTween(begin: Colors.grey, end: Colors.white).animate(controller);
    controller.forward();
//    animation.addStatusListener((status) {
//      if (status == AnimationStatus.completed) {
//        controller.reverse(from: 1.0);
//      } else if (status == AnimationStatus.dismissed) {
//        controller.forward(from: 0.0);
//      }
//    });
    controller.addListener(
      () {
        setState(() {});
        print('$frame ${controller.value}');
        frame++;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value, //Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: '#login',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0, //controller.value * 50, //controller.value, //60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  totalRepeatCount: 4,
                  repeatForever: true, //this will ignore [totalRepeatCount]
                  pause: Duration(milliseconds: 1000),
                  text: ["Let'Z Chat"],
                  textStyle: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              text: 'Log In',
              onTap: () {
                //Go to login screen.
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              text: 'Register',
              onTap: () {
//Go to registration screen.
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
