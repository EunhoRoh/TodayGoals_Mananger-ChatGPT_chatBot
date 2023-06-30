import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Data/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<ToDo> todoList = [];

  String userID = FirebaseAuth.instance.currentUser!.uid;

  // Firebase에서 ToDo 리스트를 가져오는 메서드

  void resetTodoList() {
    todoList = [];
    notifyListeners();
  }

  Future<void> getTodoList() async {
    // todoList = [];
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('todo')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todoList')
          .get();

      if (snapshot.docs.isEmpty) {
        todoList = []; // 데이터가 없을 경우 빈 리스트로 초기화
      } else {
        todoList =
            snapshot.docs.map((doc) => ToDo.fromMap(doc.data())).toList();
      }
      notifyListeners();
    } catch (error) {
      print('Failed to get ToDo list: $error');
    }
  }

  // ToDo를 Firebase에 추가하는 메서드
  Future<void> addTodo(ToDo todo, String userID) async {
    try {
      var docRef = await FirebaseFirestore.instance
          .collection('todo')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todoList')
          .add(todo.toMap());

      var todoID = docRef.id;
      todo.id = todoID;

      await docRef.update({'id': todoID});

      // 추가된 todo를 todoList에도 추가
      // todoList.add(todo);

      notifyListeners();
    } catch (error) {
      print('Failed to add ToDo: $error');
    }
  }

  // ToDo를 Firebase에서 수정하는 메서드
  Future<void> editTodo(ToDo todo, String userID) async {
    try {
      print('현재 edit할 todo 아이디: ' + todo.id!);
      await FirebaseFirestore.instance
          .collection('todo')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todoList')
          .doc(todo.id)
          .update(todo.toMap());

      // // 수정된 todo를 todoList에서 찾아 업데이트
      // var index = todoList.indexWhere((element) => element.id == todo.id);
      // if (index != -1) {
      //   todoList[index] = todo;
      // }

      notifyListeners();
    } catch (error) {
      print('Failed to edit ToDo: $error');
    }
  }

  // ToDo를 Firebase에서 삭제하는 메서드
  Future<void> deleteTodo(ToDo todo, String userID) async {
    try {
      await FirebaseFirestore.instance
          .collection('todo')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todoList')
          .doc(todo.id)
          .delete();
      notifyListeners();

      // // 삭제된 todo를 todoList에서 제거
      todoList.removeWhere((element) => element.id == todo.id);
      await FirebaseFirestore.instance
          .collection('todo')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todoList')
          .doc(todo.id)
          .delete();

      notifyListeners();
    } catch (error) {
      print('Failed to delete ToDo: $error');
    }
  }

  // ToDo의 상태 변경을 처리하는 메서드
  void handleToDoChange(ToDo todo) {
    todo.isDone = !todo.isDone;
    editTodo(todo, FirebaseAuth.instance.currentUser!.uid);
  }
}
