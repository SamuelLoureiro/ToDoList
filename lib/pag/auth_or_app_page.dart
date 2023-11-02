import 'package:flutter/material.dart';
import 'package:todolist/core/modelos/todo_user.dart';
import 'package:todolist/core/services/auth_service.dart';
import 'package:todolist/pag/ToDoList_page.dart';
import 'package:todolist/pag/auth.dart';
import 'package:todolist/pag/loading_page.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadgingPage();
        } else {
          return StreamBuilder<ToDoUser?>(
            stream: AuthService().userChanges,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadgingPage();
              } else {
                return snapshot.hasData ? ToDoListPage() : AuthPage();
              }
            },
          );
        }
      },
    );
  }
}
