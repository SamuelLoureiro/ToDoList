import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todolist/core/modelos/todo_user.dart';

import 'dart:io';
import 'dart:async';

import 'package:todolist/core/services/auth_service.dart';

class AuthFirebaseService implements AuthService {
  static ToDoUser? _currentUser;

  static final _userStream = Stream<ToDoUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toDoUser(user);
      controller.add(_currentUser);
    }
  });

  ToDoUser? get currentUser {
    return _currentUser;
  }

  Stream<ToDoUser?> get userChanges {
    return _userStream;
  }

  Future<void> signup(
    String nome,
    String email,
    String password,
    File? image,
  ) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user == null) return;

    final imageName = '${credential.user!.uid}.jpg';
    final imageURL = await _uploadUserImage(image, 'imageName');

    await credential.user?.updateDisplayName(nome);
    await credential.user?.updatePhotoURL(imageURL);

    await _saveToDoUser(_toDoUser(credential.user!, imageURL));
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;
    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }

  Future<void> _saveToDoUser(ToDoUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageURL': user.imageURL,
    });
  }

  static ToDoUser _toDoUser(User user, [String? imageURL]) {
    return ToDoUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageURL: imageURL ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
