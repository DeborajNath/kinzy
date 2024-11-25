import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _filteredTasks = [];

  List<Map<String, dynamic>> get tasks =>
      _filteredTasks.isEmpty ? _tasks : _filteredTasks;

  bool _searchInProgress = false;

  void sortTasks(String filter) {
    if (filter == "Recently Added") {
      log("Sorting by Recently Added");

      _tasks.sort((a, b) {
        if (a['createdAt'] is Timestamp && b['createdAt'] is Timestamp) {
          return (b['createdAt'] as Timestamp)
              .compareTo(a['createdAt'] as Timestamp);
        }
        return 0;
      });
    } else if (filter == "A-Z order") {
      log("Sorting by A-Z order");
      _tasks.sort((a, b) => a['title'].compareTo(b['title']));
    } else if (filter == "Z-A order") {
      log("Sorting by Z-A order");
      _tasks.sort((a, b) => b['title'].compareTo(a['title']));
    }
    log("Sorted tasks: ${_tasks.map((e) => e['title']).toList()}");
    notifyListeners();
  }

  List<Map<String, dynamic>> get filterTaskSearch {
    if (_filteredTasks.isNotEmpty) {
      return _filteredTasks;
    } else if (_searchInProgress && _filteredTasks.isEmpty) {
      return [];
    } else {
      return _tasks;
    }
  }

  // Fetch tasks from Firestore
  Future<void> fetchTasks() async {
    try {
      Query query = tasksCollection.orderBy('createdAt', descending: true);
      QuerySnapshot querySnapshot = await query.get();
      _tasks = querySnapshot.docs.map((doc) {
        // final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
          // 'createdAt': data['createdAt'] ?? Timestamp.now(),
        };
      }).toList();
      notifyListeners();
    } catch (e) {
      log("Error fetching tasks: $e");
    }
  }

  // Add a task to Firestore
  Future<void> addTask(String title, String description) async {
    try {
      DocumentReference docRef = await tasksCollection.add({
        'title': title,
        'description': description,
        'status': 'Todo',
        'createdAt': Timestamp.now(),
      });
      _tasks.add({
        'id': docRef.id,
        'title': title,
        'description': description,
        'status': 'Todo',
        'createdAt': Timestamp.now(),
      });
      notifyListeners();
      log("Task added: $title");
    } catch (e) {
      log("Error adding task: $e");
    }
  }

  // Edit a task in Firestore
  Future<void> editTask(
      String id, String title, String description, String status) async {
    try {
      await tasksCollection.doc(id).update({
        'title': title,
        'description': description,
        'status': status,
        'updatedAt': Timestamp.now(),
      });
      // Update the task in the local _tasks list
      final taskIndex = _tasks.indexWhere((task) => task['id'] == id);
      if (taskIndex != -1) {
        _tasks[taskIndex] = {
          'id': id,
          'title': title,
          'description': description,
          'status': status,
          'updatedAt': Timestamp.now(),
        };
        notifyListeners();
      }
      log("Task updated: $id");
    } catch (e) {
      log("Error updating task: $e");
    }
  }

  // Delete a task from Firestore
  Future<void> deleteTask(String id) async {
    try {
      await tasksCollection.doc(id).delete();
      _tasks.removeWhere((task) => task['id'] == id);
      notifyListeners();
      log("Task deleted: $id");
    } catch (e) {
      log("Error deleting task: $e");
    }
  }

  // Search tasks by title or description
  void searchTasks(String query) {
    _searchInProgress = query.isNotEmpty;
    if (query.isEmpty) {
      _filteredTasks.clear();
    } else {
      _filteredTasks = _tasks
          .where((task) =>
              task['title'].toLowerCase().contains(query.toLowerCase()) ||
              task['description'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
