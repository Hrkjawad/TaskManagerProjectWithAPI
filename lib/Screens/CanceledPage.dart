import 'package:flutter/material.dart';
import 'package:task_manager_assignment/Datas/Task_Model.dart';
import 'package:task_manager_assignment/Datas/NetUtils.dart';
import 'package:task_manager_assignment/Screens/AddNewTask.dart';
import 'package:task_manager_assignment/Datas/Urls.dart';
import 'package:task_manager_assignment/widgets/Tasklist_Item.dart';
import 'package:task_manager_assignment/Datas/SnackbarMessage.dart';
import 'package:task_manager_assignment/widgets/UserProfile.dart';
import 'package:task_manager_assignment/widgets/EditTasklist.dart';

class CanceledPage extends StatefulWidget {
  const CanceledPage({super.key});

  @override
  State<CanceledPage> createState() => _CanceledPageState();
}

class _CanceledPageState extends State<CanceledPage> {
  TaskModel cancelledTaskModel = TaskModel();
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    cancelTasks();
  }

  Future<void> deleteTask(dynamic id) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete!'),
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
                    cancelTasks();
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

  Future<void> cancelTasks() async {
    inProgress = true;
    setState(() {});
    final response = await NetworkUtils().getMethod(
        'https://task.teamrabbil.com/api/v1/listTaskByStatus/Cancelled');

    if (response != null) {
      cancelledTaskModel = TaskModel.fromJson(response);
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
                          cancelTasks();
                        },
                        child: ListView.builder(
                            itemCount: cancelledTaskModel.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Tasklist_Item(
                                subject:
                                    cancelledTaskModel.data?[index].title ??
                                        'Unknown',
                                description: cancelledTaskModel
                                        .data?[index].description ??
                                    'Unknown',
                                date: cancelledTaskModel
                                        .data?[index].createdDate ??
                                    'Unknown',
                                type: 'Cancelled',
                                backgroundColor: Colors.redAccent,
                                onEdit: () {
                                  editTaskList(
                                    'Completed',
                                    cancelledTaskModel.data?[index].sId ?? '',
                                    () {
                                      cancelTasks();
                                    },
                                    context,
                                  );
                                },
                                onDelete: () {
                                  deleteTask(
                                      cancelledTaskModel.data?[index].sId);
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
