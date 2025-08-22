import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopadmin/HomeScreen.dart';
import 'package:shopadmin/LoginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  checklogin() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("islogin"))
      {
        Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>HomeScreen())
        );
      }
    else
      {
        Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>LoginPage())
        );
      }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds:3)).then((val){
      checklogin();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration: BoxDecoration(
        color: Colors.white
    ),
    child:
      Center(
        child: 
        Image.asset("assets/img/logo.png",height: 119, width: 263),
      )
      )
    );
  }
}
