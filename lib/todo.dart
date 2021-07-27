import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  Todo(DocumentSnapshot? doc) {
    this.title = doc!['title'];
    final Timestamp timestamp = doc['createdAt'];
    this.createdAt = timestamp.toDate();
  }

  String? title;
  DateTime? createdAt;
}
