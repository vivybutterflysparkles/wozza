import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wozza/configs/colors.dart';
import 'package:wozza/controllers/signupcontroller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers
  final Signupcontroller signupcontroller = Get.put(Signupcontroller());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/wine.png', width: 140),
              SizedBox(height: 10),
              Text("Create Account", style: TextStyle(fontSize: 20)),
              SizedBox(height: 5),
              const Text(
                "Join the bar management team",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Username
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text(
                      "Enter Fullname",
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
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Fullname",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Email
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text(
                      "Enter Email or Phone Number",
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
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email or Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Password
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
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
                child: Obx(
                  () => TextField(
                    controller: passwordController,
                    obscureText: !signupcontroller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: "PIN or Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () => signupcontroller.togglePassword(),
                        child: Icon(
                          signupcontroller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Confirm Password
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text(
                      "Confirm Password",
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
                child: Obx(
                  () => TextField(
                    controller: confirmPasswordController,
                    obscureText: !signupcontroller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: "Confirm PIN or password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () => signupcontroller.togglePassword(),
                        child: Icon(
                          signupcontroller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Sign Up Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: GestureDetector(
                  onTap: () {
                    bool success = signupcontroller.signup(
                      usernameController.text,
                      passwordController.text,
                      confirmPasswordController.text,
                      emailController.text,
                    );

                    if (success) {
                      Get.offAndToNamed("/homescreen");
                    } else {
                      Get.snackbar(
                        "Sign Up Failed",
                        "Invalid details or passwords do not match",
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Get.toNamed("/login"),
                    child: Text(
                      "Log in",
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
