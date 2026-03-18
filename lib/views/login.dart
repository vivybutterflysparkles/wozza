import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:wozza/configs/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.deepOrangeAccent,
      //   title: Text("Logging Page", style: TextStyle(color: Colors.white)),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   "Jumia Marketplace",
              //   style: TextStyle(
              //     color: Colors.blue,
              //     fontSize: 30,
              //     fontWeight: FontWeight.w800,
              //   ),
              // ),
              Image.asset('assets/wine.png', width: 140),

              SizedBox(height: 10),

              /// App Name
              Text("Welcome back", style: TextStyle(fontSize: 20)),

              const SizedBox(height: 5),

              /// Tagline
              const Text(
                "Sign in to manage your bar",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Enter Username",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  decoration: InputDecoration(
                    hint: Text("Email or Phone Number"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Enter Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  decoration: InputDecoration(
                    hint: Text("PIN or Password"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // MaterialButton(
              //   onPressed: () {},
              //   child: Text("Login", style: TextStyle(color: Colors.white)),
              //   color: Colors.deepOrangeAccent,

              // ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: GestureDetector(
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onTap: () {
                            Get.toNamed("/homescreen");
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? "),
                          GestureDetector(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: primaryColor),
                            ),
                            onTap: () {
                              Get.toNamed("/signup");
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Forgot Password?"),
                          SizedBox(width: 5),
                          Text("Reset", style: TextStyle(color: primaryColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
