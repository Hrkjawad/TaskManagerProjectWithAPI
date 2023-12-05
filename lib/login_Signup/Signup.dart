import 'package:flutter/material.dart';
import 'package:task_manager_assignment/Screens/bg.dart';
import 'package:task_manager_assignment/login_Signup/login.dart';
import 'package:task_manager_assignment/Datas/NetUtils.dart';
import 'package:task_manager_assignment/Datas/SnackbarMessage.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController mobileTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool inProgress = false;
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
                    height: 30,
                  ),
                  Text(
                    "Join With Us",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailTextController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.name,
                    controller: firstNameTextController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "First Name",
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.name,
                    controller: lastNameTextController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter last name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Last Name",
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    controller: mobileTextController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your Mobile number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Mobile Number",
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordTextController,
                    validator: (value) {
                      if ((value?.isEmpty ?? true) &&
                          (value?.length ?? 0) < 6) {
                        return 'Please Enter your password more than 6 letters';
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
                            inProgress = true;
                            setState(() {});
                            final result = await NetworkUtils().postMethod(
                                'https://task.teamrabbil.com/api/v1/registration',
                                body: {
                                  'email': emailTextController.text.trim(),
                                  'mobile': mobileTextController.text.trim(),
                                  'password': passwordTextController.text,
                                  'firstName':
                                  firstNameTextController.text.trim(),
                                  'lastName':
                                  lastNameTextController.text.trim(),
                                });

                            inProgress = false;
                            setState(() {});
                            if (result != null && result['status'] == 'success') {
                              emailTextController.clear();
                              mobileTextController.clear();
                              passwordTextController.clear();
                              firstNameTextController.clear();
                              lastNameTextController.clear();

                              if (mounted) {
                                SnackBarMessage(context, 'Your Registration is Successful !');
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                        builder: (context) => const login()), (
                                        route) => false);
                              }
                            } else {
                              if (mounted) {
                                SnackBarMessage(
                                    context, 'Registration Failed !', true);
                              }
                            }
                          }
                        }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Have account?",
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
