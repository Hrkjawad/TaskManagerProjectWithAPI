import 'package:flutter/material.dart';
import 'package:task_manager_assignment/Datas/NetUtils.dart';
import 'package:task_manager_assignment/Datas/SnackbarMessage.dart';
import 'package:task_manager_assignment/Screens/MainPage.dart';
import 'package:task_manager_assignment/widgets/UserProfile.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({Key? key}) : super(key: key);

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: ListView(
            children: [
              const UserProfile(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add New Task',
                             style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Add Subject';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Subject',
                            ),
                            controller: subjectController,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Add subject description';
                              }
                              return null;
                            },
                            maxLines: 6,
                            decoration: const InputDecoration(
                              hintText: "Description",
                            ),
                            controller: descriptionController,
                          ),
                          const SizedBox(
                            height: 16,
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
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      inProgress = true;
                                      setState(() {});

                                      final result = await NetworkUtils().postMethod(
                                          'https://task.teamrabbil.com/api/v1/createTask',
                                          body: {
                                            "title":
                                                subjectController.text.trim(),
                                            "description":
                                                descriptionController.text.trim(),
                                            "status": "New"
                                          });
                                      inProgress = false;
                                      setState(() {});

                                      if (result != null &&
                                          result['status'] == 'success') {
                                        subjectController.clear();
                                        descriptionController.clear();
                                        if (mounted) {
                                          SnackBarMessage(context,
                                              'Task added successfully!');
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MainPage()),
                                              (route) => false);
                                        }
                                      } else {
                                        if (mounted) {
                                          SnackBarMessage(
                                              context,
                                              'Task adding failed! Try again',
                                              true);
                                        }
                                      }
                                    }
                                  }),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
