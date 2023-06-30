import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  String startTime;
  String endTime;
  String descript;

  ToDo({
    this.id,
    required this.todoText,
    this.isDone = false,
    required this.startTime,
    required this.endTime,
    required this.descript,
  });

  static List<ToDo> todoList() {
    return [];
  }

  // ToDo 객체를 Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      // 'todoID': id,
      'descript': descript,
      'endTime': endTime,
      'id': id,
      'isDone': isDone,
      'startTime': startTime,
      'todoText': todoText,
    };
  }

  // Map을 ToDo 객체로 변환하는 메서드
  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      todoText: map['todoText'],
      isDone: map['isDone'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      descript: map['descript'],
    );
  }

  bool get isEmpty => todoList.isBlank!;

  List<ToDo> map(List<Map<String, dynamic>> maps) {
    return maps.map((map) => ToDo.fromMap(map)).toList();
  }

  // Firebase에서 가져온 DocumentSnapshot을 ToDo 객체로 변환하는 메서드
  factory ToDo.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ToDo.fromMap(data);
  }
}
