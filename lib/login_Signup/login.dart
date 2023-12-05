import 'package:flutter/material.dart';
import 'package:task_manager_assignment/Screens/MainPage.dart';
import 'package:task_manager_assignment/Screens/bg.dart';
import 'package:task_manager_assignment/Screens/ForgotPassEmail.dart';
import 'package:task_manager_assignment/login_Signup/Signup.dart';
import 'package:task_manager_assignment/Datas/NetUtils.dart';
import 'package:task_manager_assignment/Datas/SnackbarMessage.dart';
import 'package:task_manager_assignment/Datas/auth-utils.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool inProgress = false;

  Future<void> login() async {
    inProgress = true;
    setState(() {});
    final result = await NetworkUtils()
        .postMethod('https://task.teamrabbil.com/api/v1/login', body: {
      'email': emailTextController.text.trim(),
      'password': passwordTextController.text
    }, onUnAuthorize: () {
      SnackBarMessage(
          context, 'Email or Password is incorrect. Please Try again!', true);
    });
    inProgress = false;
    setState(() {});
    if (result != null && result['status'] == 'success') {
      await AuthUtils.saveUserData(
        result['data']['firstName'],
        result['data']['lastName'],
        result['token'],
        result['data']['photo'],
        result['data']['mobile'],
        result['data']['email'],
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
                (route) => false);
      }
    }
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
                  const SizedBox(height: 40,),
                  Text(
                    "Get Started With",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailTextController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your valid email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Email",

                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordTextController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your valid password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (inProgress)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    ElevatedButton(
                      child: const Icon(Icons.arrow_circle_right_outlined),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          login();
                        }
                      },
                    ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassEmail(),),);
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey,),

                    ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have account?",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const Signup()),
                                (route) => false,
                          );
                        },
                        child: const Text("Sign Up"),
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
