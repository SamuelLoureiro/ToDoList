import 'package:todolist/core/modelos/todo_user.dart';
import 'dart:io';

import 'package:todolist/core/services/auth_firebase_service.dart';

abstract class AuthService {
  ToDoUser? get currentUser;

  Stream<ToDoUser?> get userChanges;

  Future<void> signup(
    String nome,
    String email,
    String password,
    File? image,
  );

  Future<void> login(
    String email,
    String password,
  );

  Future<void> logout();

  factory AuthService() {
    return AuthFirebaseService();
  }
}
