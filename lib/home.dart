import 'package:final_project/DetailTask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Data/todo.dart';
import 'EditTask.dart';
import 'NewTask.dart';
import 'Provider/loading_provider.dart';
import 'Provider/todo_provider.dart';
import 'login.dart';
import 'screens/chat_screen.dart';
import 'my_task.dart';
import 'ghost.dart';
// import 'myPage.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String filterType = "today";
  DateTime today = new DateTime.now();
  // String taskPop = "close";

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  //기간을 설정하는 변수
  // Map<DateTime, List<dynamic>> _getEventsForDay = {};

  // final todosList = ToDo.todoList();

  // Map<String, List> mySelectedEvents = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = _focusedDay;
    Provider.of<TodoProvider>(context, listen: false).getTodoList();
    // LoadingProvider loadingProvider =
    //                 Provider.of<LoadingProvider>(context, listen: false);
    print('현재 user id ' + FirebaseAuth.instance.currentUser!.uid);
    // loadPreviousEvents();
  }

  List<dynamic> _listOfDayEvents(DateTime dateTime) {
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    List<dynamic> events = [];
    DateTime selectedDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day);

    // FirebaseAuth.instance.currentUser!.uid로 사용자의 UID를 가져옵니다.

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

  List<ToDo> _listOfDayTodos(DateTime dateTime, TodoProvider todoProvider) {
    List<ToDo> events = [];
    DateTime selectedDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day);

    // FirebaseAuth.instance.currentUser!.uid로 사용자의 UID를 가져옵니다.

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

  var monthNames = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEPT",
    "OCT",
    "NOV",
    "DEC"
  ];
  // CalendarController ctrlr = new CalendarController();
  // void editTodo(BuildContext context, {required ToDo todo}) {
  //   TodoProvider todoProvider =
  //       Provider.of<TodoProvider>(context, listen: false);
  //   todoProvider.editTodo(todo, "user-id");
  // }

  // void detailTodo(ToDo todo) {
  //   TodoProvider todoProvider =
  //       Provider.of<TodoProvider>(context, listen: false);
  //   todoProvider.deleteTodo(todo, "user-id");
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Home Page',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              semanticLabel: 'signout',
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(builder: (context, todoProvider, _) {
        // todoProvider.getTodoList();

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.deepPurple,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              changeFilter("today");
                            },
                            child: Text(
                              "Today",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 4,
                            width: 120,
                            color: (filterType == "today")
                                ? Colors.white
                                : Colors.transparent,
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              changeFilter("monthly");
                            },
                            child: Text(
                              "Monthly",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 4,
                            width: 120,
                            color: (filterType == "monthly")
                                ? Colors.white
                                : Colors.transparent,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                (filterType == "monthly")
                    ? TableCalendar(
                        // calendarController: ctrlr,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        // initialCalendarFormat: CalendarFormat.week,
                        eventLoader: _listOfDayEvents,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        // focusedDay: DateTime.now(),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDate, selectedDay)) {
                            // Call `setState()` when updating the selected day
                            setState(() {
                              _selectedDate = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDate, day);
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            // Call `setState()` when updating calendar format
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          // No need to call `setState()` here
                          _focusedDay = focusedDay;
                        },
                      )
                    : Container(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today ${monthNames[today.month - 1]}, ${today.day}/${today.year}",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        if (todoProvider.todoList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Container(
                                child: Text(
                              "No Data",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          )
                        else
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    ...todoProvider.todoList.map(
                                      (todo) => taskWidget(
                                        Colors.black,
                                        todo.todoText!,
                                        'Start: ${todo.startTime}',
                                        'End: ${todo.endTime}',
                                        todo,
                                      ),
                                    )
                                    // ..._listOfDayTodos(
                                    //         _selectedDate!, todoProvider)
                                    //     .map(
                                    //   (dynamic event) => taskWidget(
                                    //       Colors.black,
                                    //       event.todoText,
                                    //       'Start: ${event.startTime}',
                                    //       'End: ${event.endTime}',
                                    //       event),
                                    // )
                                  ],
                                )
                              ],
                            ),
                          ),
                        // taskWidget(
                        //     Colors.black, "Meeting with someone", "9:00 AM"),
                        // taskWidget(
                        //     Colors.black, "Meeting with someone", "9:00 AM"),
                        // taskWidget(
                        //     Colors.black, "Take your medicines", "9:00 AM"),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 110,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 90,
                          width: MediaQuery.of(context).size.width,
                          color: Color(0xff292e4e),
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyTask()),
                                  );
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "My Task",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => Ghost()),
                              //     );
                              //   },
                              //   child: Container(
                              //     child: Column(
                              //       children: [
                              //         Icon(
                              //           Icons.help_outline,
                              //           color: Colors.white,
                              //         ),
                              //         SizedBox(
                              //           height: 5,
                              //         ),
                              //         Text(
                              //           "Ghost",
                              //           style: TextStyle(
                              //               color: Colors.white, fontSize: 15),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              Container(
                                width: 80,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen()),
                                  );
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.message,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "chatGPT",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => MyPage()),
                              //     );
                              //   },
                              //   child: Container(
                              //     child: Column(
                              //       children: [
                              //         Icon(
                              //           Icons.account_circle,
                              //           color: Colors.white,
                              //         ),
                              //         SizedBox(
                              //           height: 5,
                              //         ),
                              //         Text(
                              //           "Profile",
                              //           style: TextStyle(
                              //               color: Colors.white, fontSize: 15),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 25,
                        left: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => newTask()),
                            );
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.deepPurple
                                  ],
                                ),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                "+",
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        );
      }),
    );
  }

  Future<void> _signOut() async {
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    todoProvider.resetTodoList();

    await FirebaseAuth.instance.signOut();
    Get.to(LoginScreen());
  }

  changeFilter(String filter) {
    filterType = filter;
    setState(() {});
  }

  Slidable taskWidget(
      Color color, String title, String starttime, String endtime, ToDo todo) {
    return Slidable(
      // actionPane: SlidableDrawerActionPane(),
      child: Container(
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: Offset(0, 9),
              blurRadius: 20,
              spreadRadius: 1)
        ]),
        child: GestureDetector(
          onDoubleTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailTaskPage(
                        todo: todo,
                      )),
            );
          },
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 4)),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  Text(
                    starttime,
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  Text(
                    endtime,
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                height: 50,
                width: 5,
                color: color,
              )
            ],
          ),
        ),
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        // extentRatio: 0.3,
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            // // An action can be bigger than the others.
            // flex: 2,
            // onPressed: () => _editTodo(context, todo: todo),
            onPressed: (BuildContext context) {
              editTodo(context, todo);
            },
            backgroundColor: Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (BuildContext context) {
              // deleteTodo(context, todo);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Delete Todo'),
                    content: Text('Are you sure you want to delete this todo?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Delete'),
                        onPressed: () {
                          // Delete the todo from Firebase and update the UI
                          TodoProvider todoProvider =
                              Provider.of<TodoProvider>(context, listen: false);
                          todoProvider.deleteTodo(
                              todo, FirebaseAuth.instance.currentUser!.uid);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
    );
  }

  editTodo(BuildContext context, ToDo todo) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditTaskPage(
                  todo: todo,
                )));
    // TodoProvider todoProvider =
    //     Provider.of<TodoProvider>(context, listen: false);
    // todoProvider.editTodo(todo, "user-id");
  }

  deleteTodo(BuildContext context, ToDo todo) {
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    todoProvider.deleteTodo(todo, FirebaseAuth.instance.currentUser!.uid);
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }
}

// void _editTodo(BuildContext context, {required ToDo todo}) {
//   TodoProvider todoProvider = Provider.of<TodoProvider>(context, listen: false);
//   todoProvider.editTodo(todo, "user-id");
// }

// void _deleteTodo(BuildContext context, {required ToDo todo}) {
//   TodoProvider todoProvider = Provider.of<TodoProvider>(context, listen: false);
//   todoProvider.deleteTodo(todo, "user-id");
// }
