import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add/add_page.dart';
import 'main_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainModel()..getTodoListRealtime(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.indigo,
            accentColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: Text('TODO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              centerTitle: true,
              actions: [
                Consumer<MainModel>(builder: (context, model, child) {
                  final isActive = model.checkShouldActiveCompleteButton();
                  return TextButton(
                    onPressed: isActive
                        ? () async {
                            await model.deleteCheckedItems();
                          }
                        : null,
                    child: Text(
                      '完了',
                      style: TextStyle(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
            ),
            body: Consumer<MainModel>(builder: (context, model, child) {
              final todoList = model.todoList;
              return ListView(
                children: todoList
                    .map((todo) => ListTile(
                          title: Text(todo.title!),
                          trailing: Checkbox(
                            value: todo.isDone,
                            onChanged: (bool? value) {
                              todo.isDone = !todo.isDone;
                              model.reload();
                            },
                          ),
                          onLongPress: () async {
                            // 編集画面へ遷移
                            await showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('編集しますか？'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddPage(
                                              todo: todo,
                                            ),
                                            fullscreenDialog: true,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ))
                    .toList(),
              );
            }),
            floatingActionButton:
                Consumer<MainModel>(builder: (context, model, child) {
              return FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPage(),
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: Icon(Icons.add),
              );
            }),
          )),
    );
  }
}
