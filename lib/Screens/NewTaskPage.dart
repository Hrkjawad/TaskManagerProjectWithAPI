import 'package:flutter/material.dart';
import 'package:task_manager_assignment/Datas/Task_Model.dart';
import 'package:task_manager_assignment/Datas/NetUtils.dart';
import 'package:task_manager_assignment/Screens/AddNewTask.dart';
import 'package:task_manager_assignment/Datas/SnackbarMessage.dart';
import 'package:task_manager_assignment/Datas/Urls.dart';
import 'package:task_manager_assignment/widgets/DashboardItem.dart';
import 'package:task_manager_assignment/widgets/UserProfile.dart';
import 'package:task_manager_assignment/widgets/EditTasklist.dart';
import 'package:task_manager_assignment/widgets/Tasklist_Item.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({Key? key}) : super(key: key);

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  TaskModel newTaskModel = TaskModel();
  bool inProgress = false;
  dynamic New, Complated, Canceled, Progress;

  @override
  void initState() {
    super.initState();
    getNewTasks();
    statusCount();
    setState(() {});
  }

  Future<void> deleteTask(dynamic id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete!'),
          content: const Text("Once delete, you won't be get it back"),
          actions: [
            OutlinedButton(
              onPressed: () async {
                Navigator.pop(context);
                inProgress = true;
                setState(() {});
                await NetworkUtils().deleteMethod(Urls.deleteTaskUrl(id));
                inProgress = false;
                setState(() {});
                getNewTasks();
                statusCount();
                statusCount();
              },
              child: const Text('Yes'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getNewTasks() async {
    inProgress = true;
    setState(() {});
    final response = await NetworkUtils()
        .getMethod('https://task.teamrabbil.com/api/v1/listTaskByStatus/New');

    if (response != null) {
      newTaskModel = TaskModel.fromJson(response);
    } else {
      if (mounted) {
        SnackBarMessage(context, 'Unable to fetch data. Try again!', true);
      }
    }
    inProgress = false;
    setState(() {});
  }

  Future<void> statusCount() async {
    final responseNewTask = await NetworkUtils()
        .getMethod('https://task.teamrabbil.com/api/v1/listTaskByStatus/New');
    final getNewTaskModel = TaskModel.fromJson(responseNewTask);

    setState(() {
      New = "${getNewTaskModel.data?.length ?? 0}";
    });

    final responseCancelTask = await NetworkUtils().getMethod(
        'https://task.teamrabbil.com/api/v1/listTaskByStatus/Cancelled');
    final getCaneTaskModel = TaskModel.fromJson(responseCancelTask);
    setState(() {
      Complated = "${getCaneTaskModel.data?.length ?? 0}";
    });

    final responseCompletedTask = await NetworkUtils().getMethod(
        'https://task.teamrabbil.com/api/v1/listTaskByStatus/Completed');
    final getCompletedTaskModel = TaskModel.fromJson(responseCompletedTask);
    setState(() {
      Canceled = "${getCompletedTaskModel.data?.length ?? 0}";
    });

    final responseProgressTask = await NetworkUtils().getMethod(
        'https://task.teamrabbil.com/api/v1/listTaskByStatus/Progress');
    final getProgressTaskModel = TaskModel.fromJson(responseProgressTask);
    setState(() {
      Progress = "${getProgressTaskModel.data?.length ?? 0}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfile(),
            Row(
              children: [
                Expanded(
                  child: DashboardItem(
                    typeOfTask: 'New',
                    numberOfTask: New,
                  ),
                ),
                Expanded(
                  child: DashboardItem(
                    typeOfTask: 'Completed',
                    numberOfTask: Canceled,
                  ),
                ),
                Expanded(
                  child: DashboardItem(
                    typeOfTask: 'Cancelled',
                    numberOfTask: Complated,
                  ),
                ),
                Expanded(
                  child: DashboardItem(
                    typeOfTask: 'In Progress',
                    numberOfTask: Progress,
                  ),
                ),
              ],
            ),
            Expanded(
              child: inProgress
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        getNewTasks();
                        statusCount();
                      },
                      child: ListView.builder(
                        itemCount: newTaskModel.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Tasklist_Item(
                            subject:
                                newTaskModel.data?[index].title ?? 'Unknown',
                            description:
                                newTaskModel.data?[index].description ??
                                    'Unknown',
                            date: newTaskModel.data?[index].createdDate ??
                                'Unknown',
                            type: 'New',
                            backgroundColor: Colors.lightBlueAccent,
                            onEdit: () {
                              editTaskList(
                                'New',
                                newTaskModel.data?[index].sId ?? '',
                                () {
                                  getNewTasks();
                                  statusCount();
                                  setState(() {});
                                },
                                context,
                              );
                            },
                            onDelete: () {
                              deleteTask(newTaskModel.data?[index].sId);
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewTask()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
