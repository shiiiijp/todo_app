import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  Todo(DocumentSnapshot? doc) {
    documentID = doc!.id;
    documentReference = doc.reference;
    title = doc['title'];
    final Timestamp timestamp = doc['createdAt'];
    createdAt = timestamp.toDate();
  }

  String? title;
  DateTime? createdAt;
  bool isDone = false;
  DocumentReference? documentReference;
  String? documentID;
}
