import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../todo.dart';
import 'add_model.dart';

class AddPage extends StatelessWidget {
  AddPage({this.todo});

  final Todo? todo;

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = (todo != null);
    final textEditingController = TextEditingController();

    if (isUpdate) {
      textEditingController.text = todo!.title!;
    }

    return ChangeNotifierProvider<AddModel>(
      create: (_) => AddModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isUpdate ? 'TODOを編集' : 'TODOを追加'),
        ),
        body: Consumer<AddModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: isUpdate ? "TODOを編集" : "新しいTODOを追加",
                    hintText: "例) 買い物に行く",
                  ),
                  onChanged: (text) {
                    model.todoText = text;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    isUpdate
                        ? await update(model, context)
                        : await add(model, context);
                  },
                  child: Text(isUpdate ? '更新する' : '追加する'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future add(AddModel model, BuildContext context) async {
    try {
      await model.add();
      await _showDialog(context, '保存しました');
      Navigator.pop(context);
    } catch (e) {
      _showDialog(context, e.toString());
    }
  }

  Future update(AddModel model, BuildContext context) async {
    try {
      await model.update(todo!);
      await _showDialog(context, '更新しました');
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future _showDialog(
    BuildContext context,
    String title,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
