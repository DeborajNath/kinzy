import 'package:authentication_firebase/components/primary_button.dart';
import 'package:authentication_firebase/components/willpop.dart';
import 'package:authentication_firebase/constants/index.dart';
import 'package:authentication_firebase/provider/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:authentication_firebase/main_screens/login_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = 'Recently Added';
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).fetchTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _viewDetails(BuildContext context,
      {String? taskId,
      String? title,
      String? description,
      String? status}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardBackgrround,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            title ?? "Task Details",
            style: TextStyle(
              color: primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description:",
                style: TextStyle(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description ?? "No description available",
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 10),
              Text(
                "Status:",
                style: TextStyle(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: status == "Completed"
                        ? Colors.green
                        : status == "On-Progress"
                            ? Colors.yellow
                            : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status ?? "Unknown",
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTaskDialog(BuildContext context,
      {String? taskId,
      String? title,
      String? description,
      String? status}) async {
    final TextEditingController titleController =
        TextEditingController(text: title);
    final TextEditingController descriptionController =
        TextEditingController(text: description);
    String selectedStatus = status ?? 'Todo';

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: cardBackgrround,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              taskId == null ? "Add Task" : "Edit Task",
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    // labelText: "Title",
                    hintText: taskId == null ? "Title" : title,
                    labelStyle: TextStyle(color: primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    // labelText: "Description",
                    hintText: taskId == null ? "Description" : description,
                    labelStyle: TextStyle(color: primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                taskId != null
                    ? Row(
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(
                                color: primaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                          const Spacer(),
                          DropdownButton<String>(
                            value: selectedStatus,
                            items: ["Todo", "On-Progress", "Completed"]
                                .map((status) => DropdownMenuItem<String>(
                                      value: status,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 8,
                                            backgroundColor:
                                                status == "Completed"
                                                    ? Colors.green
                                                    : status == "On-Progress"
                                                        ? Colors.yellow
                                                        : Colors.red,
                                          ),
                                          const SizedBox(width: 20),
                                          Text(status),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedStatus = value;
                                });
                              }
                            },
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => RoutingService.goBack(context),
                child: Text("Cancel", style: TextStyle(color: red)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                onPressed: () async {
                  final title = titleController.text.trim();
                  final description = descriptionController.text.trim();

                  if (taskId == null) {
                    if (title.isEmpty || description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Both fields are required!")),
                      );
                      return;
                    }
                    await Provider.of<TaskProvider>(context, listen: false)
                        .addTask(title, description);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Task Added: $title")),
                    );
                  } else {
                    // Edit task logic
                    await Provider.of<TaskProvider>(context, listen: false)
                        .editTask(taskId, title, description, selectedStatus);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Task Updated")),
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text(
                  taskId == null ? "Add Task" : "Update Task",
                  style: TextStyle(color: cardBackgrround),
                ),
              ),
            ],
          );
        });
      },
    );
  }

// Function to handle delete
  void _handleDeleteTask(BuildContext context, String taskId) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await Provider.of<TaskProvider>(context, listen: false)
          .deleteTask(taskId);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Task Deleted")));
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);

    // Listen for search input changes
    _searchController.addListener(() {
      String query = _searchController.text;
      taskProvider.searchTasks(query);
    });
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: cardBackgrround,
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(
            "TODO List",
            style: TextStyle(
              color: cardBackgrround,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () async {
                  await loginProvider.logOut();
                  RoutingService.gotoWithoutBack(
                    context,
                    const LoginPage(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: red,
                  ),
                  child: Text(
                    "Logout",
                    style: TextStyle(color: cardBackgrround, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: GradientButton(
            onTap: () => _showTaskDialog(context), text: "Add Task"),
        body: taskProvider.tasks.isEmpty
            ? Center(
                child: Text(
                  "No tasks available. Add one!",
                  style: TextStyle(color: primaryTextColor, fontSize: 16),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (query) {
                              taskProvider.searchTasks(query);
                            },
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                                labelText: "Search"),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DropdownButton<String>(
                          value: selectedFilter,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedFilter = newValue;
                              });
                              taskProvider.sortTasks(newValue);
                            }
                          },
                          items: ["Recently Added", "A-Z order", "Z-A order"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    taskProvider.filterTaskSearch.isEmpty
                        ? Image.asset("assets/no_data_found.jpg")
                        : Expanded(
                            child: ListView.builder(
                              itemCount: taskProvider.tasks.length,
                              itemBuilder: (context, index) {
                                final task = taskProvider.tasks[index];
                                return Card(
                                  color: cardBackgrround,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              task['title'],
                                              style: TextStyle(
                                                  color: primaryTextColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const Spacer(),
                                            CircleAvatar(
                                              backgroundColor: task['status'] ==
                                                      "Completed"
                                                  ? green
                                                  : task['status'] ==
                                                          "On-Progress"
                                                      ? Colors.yellow
                                                      : task['status'] == "Todo"
                                                          ? red
                                                          : grey,
                                              maxRadius: 8,
                                            )
                                          ],
                                        ),
                                        Text(
                                          task['description'],
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          task['createdAt'] != null
                                              ? 'Created At: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(task['createdAt'].toDate())}'
                                              : 'No creation date',
                                          style: TextStyle(
                                              color: grey, fontSize: 14),
                                        ),
                                        const SizedBox(height: 5),
                                        // Check if the task has an updated time
                                        Text(
                                          task['updatedAt'] != null
                                              ? 'Updated At: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(task['updatedAt'].toDate())}'
                                              : 'Not updated yet',
                                          style: TextStyle(
                                              color: grey, fontSize: 14),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () => _handleDeleteTask(
                                                  context, task['id']),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                decoration: BoxDecoration(
                                                  color: red,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: cardBackgrround),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _showTaskDialog(context,
                                                    taskId: task['id'],
                                                    title: task['title'],
                                                    description:
                                                        task['description']);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.lightBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                                child: Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                      color: cardBackgrround),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _viewDetails(
                                                  context,
                                                  taskId: task['id'],
                                                  title: task['title'],
                                                  description:
                                                      task['description'],
                                                  status: task['status'],
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                                child: Text(
                                                  "View Details",
                                                  style: TextStyle(
                                                      color: cardBackgrround),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
              ),
      ),
    );
  }
}
