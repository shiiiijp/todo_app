import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_model.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddModel>(
      create: (_) => AddModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('TODOを追加'),
        ),
        body: Consumer<AddModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "追加するTODOを入力",
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
                    // Firestoreに値を追加する
                    await model.add();
                    Navigator.pop(context);
                  },
                  child: Text('追加する'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
