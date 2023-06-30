import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Data/todo.dart';

class LoadingProvider extends ChangeNotifier {
  String? userID;

  // userID를 user Collection에 저장하는 메서드
  Future<void> saveUserID(String uid, String email, String name) async {
    try {
      // user Collection의 document에 userID로 저장
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .set({'uid': uid});
      userID = uid;
      notifyListeners();
    } catch (error) {
      print('Failed to save userID: $error');
    }
  }

  // 로그인한 사용자의 uid를 가져오는 메서드
  Future<String?> getCurrentUserID() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }

  // userID의 ToDo들을 가져와서 todolist에 저장하는 메서드
  Future<void> fetchToDos() async {
    try {
      if (userID == null) {
        userID = await getCurrentUserID();
      }

      if (userID != null) {
        // 현재 userID로 user Collection에서 Document 가져오기
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(userID)
            .get();
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          // userID의 todoList subcollection에서 ToDo들 가져오기
          QuerySnapshot todoSnapshot = await FirebaseFirestore.instance
              .collection('todo')
              .doc(userID)
              .collection('todoList')
              .get();
          List<ToDo> todos =
              todoSnapshot.docs.map((doc) => ToDo.fromSnapshot(doc)).toList();

          // 가져온 ToDo들을 todolist에 저장
          // 예시로 print로 출력
          todos.forEach((todo) {
            print('ToDo: ${todo.todoText}');
          });
        }
      }
    } catch (error) {
      print('Failed to fetch ToDos: $error');
    }
  }
}
