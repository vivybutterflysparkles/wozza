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
  // 1. Initialize Controllers inside the State
  final Signupcontroller signupcontroller = Get.put(Signupcontroller());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    // Clean up memory when screen is closed
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/wine.png', width: 140),
              const SizedBox(height: 10),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "Join the bar management team",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Fullname Field
              _buildLabel("Enter Fullname"),
              _buildTextField(usernameController, "Fullname", Icons.person),
              const SizedBox(height: 20),

              // Email Field
              _buildLabel("Enter Email or Phone Number"),
              _buildTextField(
                emailController,
                "Email or Phone Number",
                Icons.email,
              ),
              const SizedBox(height: 20),

              // Password Field
              _buildLabel("Enter Password"),
              Obx(
                () => _buildPasswordField(
                  passwordController,
                  "PIN or Password",
                  signupcontroller.isPasswordVisible.value,
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password Field
              _buildLabel("Confirm Password"),
              Obx(
                () => _buildPasswordField(
                  confirmPasswordController,
                  "Confirm PIN or password",
                  signupcontroller.isPasswordVisible.value,
                ),
              ),
              const SizedBox(height: 30),

              // SIGN UP BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => GestureDetector(
                    onTap: signupcontroller.isLoading.value
                        ? null // Disable button while loading
                        : () async {
                            // Call the controller with the 4 expected arguments
                            bool success = await signupcontroller.signup(
                              usernameController.text,
                              passwordController.text,
                              confirmPasswordController.text,
                              emailController.text,
                            );

                            if (success) {
                              // If PHP returns success: true, go to home
                              Get.offAllNamed("/homescreen");
                            }
                          },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: signupcontroller.isLoading.value
                            ? Colors.grey
                            : primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: signupcontroller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Navigation to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Get.toNamed("/login"),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets to keep the code clean
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hint,
    bool isVisible,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () => signupcontroller.togglePassword(),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
