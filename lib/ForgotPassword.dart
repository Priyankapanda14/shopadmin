import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 200),
              Center(
                child: Image.asset("assets/img/logo.png", height: 100, width: 185),
              ),
              SizedBox(height: 30),
              Text("Email", style: TextStyle(fontFamily: "Poppins_semibold", fontSize: 16.0)),
              SizedBox(height: 8),
              TextField(
                decoration:  InputDecoration(
                  hintText: "Enter your email",
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                ),
              ),

              SizedBox(height: 30),


              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  child: Text('Send',
                    style: TextStyle(
                    fontFamily: "Poppins_medium",
                    fontSize: 18,
                    ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,

                  ),
                  onPressed: () {},
                ),
              )





            ],
          ),
        ),
      ),
    );
  }
}
