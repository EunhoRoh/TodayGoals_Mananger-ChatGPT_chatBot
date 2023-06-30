import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Data/todo.dart';
import 'Provider/todo_provider.dart';
import 'home.dart';
import 'package:intl/intl.dart';

class DetailTaskPage extends StatefulWidget {
  final ToDo todo;

  const DetailTaskPage({required this.todo});

  @override
  _DetailTaskPageState createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  final titleController = TextEditingController();
  final descpController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.todo.todoText!;
    descpController.text = widget.todo.descript;
    startDate = DateTime.parse(widget.todo.startTime);
    endDate = DateTime.parse(widget.todo.endTime);
  }

  @override
  void dispose() {
    titleController.dispose();
    descpController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate!,
      firstDate: DateTime(2021),
      lastDate: DateTime(2099),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate!,
      firstDate: DateTime(2021),
      lastDate: DateTime(2099),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future<void> _updateTask() async {
    if (titleController.text.isEmpty || descpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Required title and description'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      String startTime = DateFormat('yyyy-MM-dd').format(startDate!);
      String endTime = DateFormat('yyyy-MM-dd').format(endDate!);

      ToDo updatedTodo = ToDo(
        id: widget.todo.id,
        todoText: titleController.text,
        descript: descpController.text,
        startTime: startTime,
        endTime: endTime,
        isDone: widget.todo.isDone,
      );

      // Update the todo in Firebase

      TodoProvider todoProvider =
          Provider.of<TodoProvider>(context, listen: false);
      await todoProvider.editTodo(
          updatedTodo, FirebaseAuth.instance.currentUser!.uid);
      // try {
      //   TodoProvider todoProvider =
      //       Provider.of<TodoProvider>(context, listen: false);
      //   await todoProvider.editTodo(
      //       updatedTodo, FirebaseAuth.instance.currentUser!.uid);
      // } catch (error) {
      //   print('Failed to update ToDo: $error');
      // }

      titleController.clear();
      descpController.clear();

      // Navigate back to the HomePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Text(
          "Detail Goal",
          // style: TextStyle(fontSize: 25),
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: 30,
              color: Colors.deepPurple,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Title",
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            color: Colors.grey.withOpacity(0.2),
                            child: TextField(
                              readOnly: true,
                              controller: titleController,
                              decoration: InputDecoration(
                                  hintText: "Title", border: InputBorder.none),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Description",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15)),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5))),
                            child: TextField(
                              readOnly: true,
                              controller: descpController,
                              maxLines: 6,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Add description here",
                              ),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Duration",
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.grey.withOpacity(0.2),
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: startDate != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(startDate!)
                                    : "Start Date",
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.grey.withOpacity(0.2),
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: endDate != null
                                    ? DateFormat('yyyy-MM-dd').format(endDate!)
                                    : "End Date",
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(10),
                          //   color: Colors.grey.withOpacity(0.2),
                          //   child: TextField(
                          //     decoration: InputDecoration(
                          //       hintText: "Start Date",
                          //       border: InputBorder.none,
                          //     ),
                          //     style: TextStyle(fontSize: 18),
                          //   ),
                          // ),
                          // Container(
                          //   padding: EdgeInsets.all(10),
                          //   color: Colors.grey.withOpacity(0.2),
                          //   child: TextField(
                          //     decoration: InputDecoration(
                          //       hintText: "End Date",
                          //       border: InputBorder.none,
                          //     ),
                          //     style: TextStyle(fontSize: 18),
                          //   ),
                          // ),

//
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
