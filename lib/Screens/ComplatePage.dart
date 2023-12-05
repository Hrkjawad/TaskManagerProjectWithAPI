import 'package:flutter/material.dart';
import 'package:task_manager_assignment/Datas/Task_Model.dart';
import 'package:task_manager_assignment/Datas/NetUtils.dart';
import 'package:task_manager_assignment/Screens/AddNewTask.dart';
import 'package:task_manager_assignment/Datas/Urls.dart';
import 'package:task_manager_assignment/widgets/EditTasklist.dart';
import 'package:task_manager_assignment/widgets/Tasklist_Item.dart';
import 'package:task_manager_assignment/Datas/SnackbarMessage.dart';
import 'package:task_manager_assignment/widgets/UserProfile.dart';

class ComplatePage extends StatefulWidget {
  const ComplatePage({super.key});

  @override
  State<ComplatePage> createState() => _ComplatePageState();
}

class _ComplatePageState extends State<ComplatePage> {
  TaskModel completedTaskModel = TaskModel();
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    completedNewTasks();
  }

  Future<void> deleteTask(dynamic id) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete !'),
            content:
                const Text("Warning! Once delete, you won't be get it back"),
            actions: [
              OutlinedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    inProgress = true;
                    setState(() {});
                    await NetworkUtils().deleteMethod(Urls.deleteTaskUrl(id));
                    inProgress = false;
                    setState(() {});
                    completedNewTasks();
                  },
                  child: const Text('Yes')),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
            ],
          );
        });
  }

  Future<void> completedNewTasks() async {
    inProgress = true;
    setState(() {});
    final response = await NetworkUtils().getMethod(
        'https://task.teamrabbil.com/api/v1/listTaskByStatus/Completed');

    if (response != null) {
      completedTaskModel = TaskModel.fromJson(response);
    } else {
      if (mounted) {
        SnackBarMessage(context, 'Unable to fetch data. Try again!', true);
      }
    }
    inProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfile(),
            Expanded(
                child: inProgress
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          completedNewTasks();
                        },
                        child: ListView.builder(
                            itemCount: completedTaskModel.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Tasklist_Item(
                                subject:
                                    completedTaskModel.data?[index].title ??
                                        'Unknown',
                                description: completedTaskModel
                                        .data?[index].description ??
                                    'Unknown',
                                date: completedTaskModel
                                        .data?[index].createdDate ??
                                    'Unknown',
                                type: 'Completed',
                                backgroundColor: Colors.green,
                                onEdit: () {
                                  editTaskList(
                                    'Completed',
                                    completedTaskModel.data?[index].sId ?? '',
                                    () {
                                      completedNewTasks();
                                    },
                                    context,
                                  );
                                },
                                onDelete: () {
                                  deleteTask(
                                      completedTaskModel.data?[index].sId);
                                },
                              );
                            }),
                      )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNewTask()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
