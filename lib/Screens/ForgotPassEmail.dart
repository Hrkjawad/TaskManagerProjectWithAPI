import 'package:flutter/material.dart';
import 'package:task_manager_assignment/Screens/bg.dart';
import 'package:task_manager_assignment/login_Signup/login.dart';
import 'package:task_manager_assignment/Screens/ForgotPassPinVerification.dart';
import 'package:task_manager_assignment/Datas/NetUtils.dart';
import 'package:task_manager_assignment/Datas/SnackbarMessage.dart';
import 'package:task_manager_assignment/Datas/Urls.dart';

class ForgotPassEmail extends StatefulWidget {
  const ForgotPassEmail({Key? key}) : super(key: key);


  @override
  State<ForgotPassEmail> createState() => _ForgotPassEmailState();
}

class _ForgotPassEmailState extends State<ForgotPassEmail> {
  bool inProgess = false;

  final TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                    "Your Email Address",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                      "A 6 digit verification pin will send to your email address",
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (inProgess)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    ElevatedButton(
                      child: const Icon(Icons.arrow_circle_right_outlined),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          inProgess = true;
                          setState(() {});

                          final response = await NetworkUtils().getMethod(
                              Urls.recoveryEmailUrl(emailController.text.trim()));
                          if (response != null &&
                              response['status'] == 'success') {
                            if (mounted) {
                              SnackBarMessage(
                                  context, 'OTP sent to email address');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassPinVerification(
                                        email: emailController.text.trim(),
                                      )));
                            }
                          } else {
                            if (mounted) {
                              SnackBarMessage(
                                  context, 'OTP sent failed. Try again!', true);
                            }
                          }
                          inProgess = false;
                          setState(() {});
                        }
                      },
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have account?",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const login(),
                            ),
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
