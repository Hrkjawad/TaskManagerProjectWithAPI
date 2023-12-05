import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:task_manager_assignment/Datas/NetUtils.dart';
import 'package:task_manager_assignment/Datas/SnackbarMessage.dart';
import 'package:task_manager_assignment/Datas/auth-utils.dart';
import 'package:task_manager_assignment/Screens/bg.dart';
import 'package:task_manager_assignment/widgets/UserProfile.dart';
import 'package:task_manager_assignment/Screens/MainPage.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  XFile? pickedImage;
  static String? base64Image;
  bool inProgress = false;

  Future<void> updateProfile() async {
    inProgress = true;
    setState(() {});
    if (pickedImage != null) {
      List<int> imageBytes = await pickedImage!.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    Map<String, String> bodyParams = {
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'mobile': mobileController.text.trim(),
      'password': passwordController.text,
      'photo': base64Image ?? ''
    };

    if (passwordController.text.isNotEmpty) {
      bodyParams['password'] = passwordController.text;
    }

    final result = await NetworkUtils().postMethod(
        'https://task.teamrabbil.com/api/v1/profileUpdate',
        body: bodyParams);
    if (result != null && result['status'] == 'success') {
      if (mounted) {
        SnackBarMessage(context, 'Profile Updated');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
            (route) => false);
      }
      setState(() {});
      AuthUtils.saveUserData(
          result['data']['firstName'] = firstNameController.text.trim(),
          result['data']['lastName'] = lastNameController.text.trim(),
          result['token'] = AuthUtils.token ?? '',
          result['data']['photo'] = base64Image ?? '',
          result['data']['mobile'] = mobileController.text.trim(),
          result['data']['email'] = emailController.text.trim());
    } else {
      if (mounted) {
        SnackBarMessage(context, 'Update failed. Try again!', true);
      }
    }
    inProgress = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    emailController.text = AuthUtils.email ?? '';
    firstNameController.text = AuthUtils.firstName ?? '';
    lastNameController.text = AuthUtils.lastName ?? '';
    mobileController.text = AuthUtils.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const UserProfile(),
              Expanded(
                child: background(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Update Profile',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () async {
                              imagePickerFunction();
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8))),
                                  child: const Text('Photos'),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8))),
                                    child: Text(
                                      pickedImage?.name ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Email',
                            ),
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: true,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'First Name',
                            ),
                            controller: firstNameController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Last Name',
                            ),

                            controller: lastNameController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Mobile Number',
                            ),
                            keyboardType: TextInputType.number,
                            controller: mobileController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter mobile number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                            controller: passwordController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          if (inProgress)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  child: const Icon(
                                      Icons.arrow_circle_right_outlined),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      updateProfile();
                                    }
                                  }),
                            )
                        ],
                      ),
                    ),
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> imagePickerFunction() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pick Your Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Gallery'),
                  leading: const Icon(Icons.image),
                  onTap: () async {
                    pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {});
                    }
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  title: const Text('Camera'),
                  leading: const Icon(Icons.camera_alt_outlined),
                  onTap: () async {
                    pickedImage = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      setState(() {});
                    }
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          );
        });
  }
}
