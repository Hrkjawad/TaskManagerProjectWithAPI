import 'package:flutter/material.dart';
import 'package:task_manager_assignment/Screens/bg.dart';
import 'package:task_manager_assignment/login_Signup/login.dart';
import 'package:task_manager_assignment/Datas/Urls.dart';
import 'package:task_manager_assignment/Datas/NetUtils.dart';
import 'package:task_manager_assignment/Datas/SnackbarMessage.dart';

class SetPassword extends StatefulWidget {
  final String email, otp;

  const SetPassword({Key? key, required this.email, required this.otp})
      : super(key: key);

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Enter your new password';
    }
    if (value!.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    // Check for a combination of letters and numbers
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).*$').hasMatch(value)) {
      return 'Password must contain both letters and numbers';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: background(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 55,
                  ),
                  Text(
                    "Set Password",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                      "Minimum length password 8 characters with a combination of letters and numbers",
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: newPasswordController,
                    validator: validatePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    validator: (String? value) {
                      if ((value?.isEmpty ?? true) ||
                          ((value ?? '') != newPasswordController.text)) {
                        return 'Password mismatch';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Confirm Password",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Set button color to green
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (mounted) {
                          final response = await NetworkUtils().postMethod(
                            Urls.resetPasswordUrl,
                            body: {
                              "email": widget.email,
                              "OTP": widget.otp,
                              "password": newPasswordController.text
                            },
                          );
                          if (response != null &&
                              response['status'] == 'success') {
                            if (mounted) {
                              SnackBarMessage(
                                  context, 'Password reset success!');
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const login(),
                                ),
                                    (route) => false,
                              );
                            }
                          } else {
                            if (mounted) {
                              SnackBarMessage(
                                  context,
                                  'Password reset failed. Try again!',
                                  true);
                            }
                          }
                        }
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const login(),
                            ),
                                (route) => false,
                          );
                        },
                        child: const Text("Sign in"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
