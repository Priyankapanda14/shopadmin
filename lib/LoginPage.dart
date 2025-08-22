import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopadmin/ForgotPassword.dart';
import 'HomeScreen.dart';
import 'constants/UrlHelper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Please enter both username and password")),
      );
      return;
    }

    setState(() => isLoading = true);

    Uri url = Uri.parse(UrlHelper.LOGIN_VIEW);
    //Uri url = Uri.parse("https://cataloge.infinityfreeapp.com/shopping/loginpage.php");
    print("url = ${url}");
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
    });

    print("responce = ${response.statusCode}");

    setState(() => isLoading = false);

    print("isloading = ${isLoading}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("data = ${data}");

      if (data["status"] == "yes") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("islogin", "yes");

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"].toString())),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Server error. Please try again later.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(height: 200),
              Center(
                child: Image.asset("assets/img/logo.png", height: 180, width: 185),
              ),
               SizedBox(height: 30),
               Text("Username", style: TextStyle(fontFamily: "Poppins_semibold", fontSize: 16.0)),
               SizedBox(height: 8),
              TextField(
                controller: usernameController,
                decoration:  InputDecoration(
                  hintText: "Enter username",
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                ),
              ),
               SizedBox(height: 20),
               Text("Password", style: TextStyle(fontFamily: "Poppins_semibold", fontSize: 16.0)),
               SizedBox(height: 8),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: "Enter password",
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                ),
              ),
               SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> ForgotPassword())
                  );
                },
                child:Text("forgot password!",style: TextStyle(color: Colors.red,fontSize: 14,fontFamily: "Poppins_medium"),),

              ),
              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: isLoading ? null : loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    disabledBackgroundColor: Colors.orange.shade200,
                  ),
                  child: isLoading
                      ?  CircularProgressIndicator(color: Colors.white)
                      :  Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "Poppins_medium",
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
               SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

