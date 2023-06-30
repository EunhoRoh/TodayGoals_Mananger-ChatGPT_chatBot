import 'package:final_project/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'Data/todo.dart';
import 'Data/todo_item.dart';
import 'Provider/todo_provider.dart';

class MyTask extends StatefulWidget {
  @override
  _MyTask createState() => _MyTask();
}

class _MyTask extends State<MyTask> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  // final todosList = ToDo.todoList();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = _selectedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onNextDay() {
    setState(() {
      _selectedDay = _selectedDay.add(Duration(days: 1));
      _focusedDay = _selectedDay;
    });
  }

  void _onPreviousDay() {
    setState(() {
      _selectedDay = _selectedDay.subtract(Duration(days: 1));
      _focusedDay = _selectedDay;
    });
  }

  List<ToDo> _listOfDayEvents(DateTime dateTime, TodoProvider todoProvider) {
    List<ToDo> events = [];
    DateTime selectedDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day);
    for (ToDo todo in todoProvider.todoList) {
      DateTime todoStartTime = DateTime.parse(todo.startTime);
      DateTime todoEndTime = DateTime.parse(todo.endTime);

      if (selectedDate.isAtSameMomentAs(todoStartTime) ||
          selectedDate.isAtSameMomentAs(todoEndTime) ||
          (selectedDate.isAfter(todoStartTime) &&
              selectedDate.isBefore(todoEndTime))) {
        events.add(todo);
      }
    }

    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(builder: (context, todoProvider, _) {
      List<ToDo> events = _listOfDayEvents(_selectedDay, todoProvider);
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 218, 206, 238),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
              backgroundColor: Colors.deepPurple,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  DateFormat('yy.MM.dd.EEE').format(_selectedDay),
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.house,
                          size: 40,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Get.to(HomePage());
                        },
                      ),
                      // Text(
                      //   'HOME',
                      //   style: TextStyle(color: Colors.black),
                      // ),
                    ],
                  ),
                ),
              ]),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visibility(
            //   child: TableCalendar(
            //     // headerStyle: HeaderStyle(
            //     //   formatButtonVisible: false,
            //     // ),

            //     focusedDay: _focusedDay,
            //     firstDay: DateTime(2020),
            //     lastDay: DateTime(2090),
            //     selectedDayPredicate: (day) {
            //       return isSameDay(_selectedDay, day);
            //     },
            //     onDaySelected: _onDaySelected,
            //   ),
            //   // maintainSize: true,
            //   maintainAnimation: true,
            //   maintainState: true,
            //   visible: false,
            // ),

            SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  ToDo todo = events[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: ToDoItem(
                      todo: todo,
                      onToDoChanged: todoProvider.handleToDoChange,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: _onPreviousDay,
                    color: Color(0xFF9C27B0),
                    iconSize: 50,
                  ),
                  const SizedBox(
                    width: 150,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: _onNextDay,
                    color: Color(0xFF9C27B0),
                    iconSize: 50,
                  ),
                  // const SizedBox(
                  //   width: 1,
                  // ),
                ],
              ),
            ),
            SizedBox(height: 80),

            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: todoProvider.todoList
            //           .map(
            //             (dynamic event) => ToDoItem(
            //               todo: event,
            //               onToDoChanged: todoProvider.handleToDoChange,
            //             ),
            //           )
            //           .toList(),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 16),
          ],
        ),
      );
    });
  }

  // void _handleToDoChange(ToDo todo) {
  //   setState(() {
  //     todo.isDone = !todo.isDone;
  //   });
  // }
}
