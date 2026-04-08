import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Simplified import
import 'package:wozza/configs/colors.dart';
import 'package:wozza/controllers/logincontroller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Move controllers inside the state
  final Logincontroller logincontroller = Get.put(Logincontroller());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Good practice: dispose of text controllers
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50), // Added some top space
              Image.asset('assets/wine.png', width: 140),
              const SizedBox(height: 10),
              const Text("Welcome back", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 5),
              const Text(
                "Sign in to manage your bar",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Username Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username", // Better than a separate Text widget
                    hintText: "Email or Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => TextField(
                    obscureText: !logincontroller.isPasswordVisible.value,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "PIN or Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        // Used IconButton for better touch response
                        icon: Icon(
                          logincontroller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => logincontroller.togglePassword(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Login Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    // Show a loading dialog or state here if needed
                    bool success = await logincontroller.login(
                      usernameController.text,
                      passwordController.text,
                    );

                    if (success) {
                      Get.offAndToNamed("/homescreen");
                    } else {
                      Get.snackbar(
                        "Login Failed",
                        "Invalid username or password",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
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
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // ... Rest of your Sign Up / Forgot password rows
            ],
          ),
        ),
      ),
    );
  }
}
