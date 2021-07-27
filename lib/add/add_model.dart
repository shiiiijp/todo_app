import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../todo.dart';

class AddModel extends ChangeNotifier {
  String todoText = '';

  Future add() async {
    if (todoText.isEmpty) {
      throw ('TODOを入力してください');
    }

    final collection = FirebaseFirestore.instance.collection('todoList');
    await collection.add({
      'title': todoText,
      'createdAt': Timestamp.now(),
    });
  }

  Future update(Todo todo) async {
    if (todoText.isEmpty) {
      throw ('TODOを入力してください');
    }

    final document =
        FirebaseFirestore.instance.collection('todoList').doc(todo.documentID);
    document.update({
      'title': todoText,
      'updatedAt': Timestamp.now(),
    });
  }
}
