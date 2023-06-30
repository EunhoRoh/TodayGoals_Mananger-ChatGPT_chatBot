import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Ghost extends StatefulWidget {
  @override
  _Ghost createState() => _Ghost();
}

class _Ghost extends State<Ghost> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: [
          // AppBar(
          //   backgroundColor: Colors.deepPurple,
          //   elevation: 0,
          //   title: Text(
          //     "Work List",
          //     style: TextStyle(fontSize: 30),
          //   ),
          //   actions: [
          //     IconButton(
          //       icon: Icon(
          //         Icons.short_text,
          //         color: Colors.white,
          //         size: 30,
          //       ),
          //       onPressed: () {},
          //     )
          //   ],
          // ),
          // Container(
          //   color: Colors.deepPurple,
          //   height: 30,
          // ),

          // AnimatedTextKit(
          //   animatedTexts: [
          //     TyperAnimatedText('Be the Ghoast'),
          //     TyperAnimatedText('Good man'),
          //     TyperAnimatedText('Good girl',
          //         textStyle: TextStyle(
          //           fontSize: 25,
          //           fontWeight: FontWeight.bold,
          //         )),
          //   ],
          // ),
          // TextLiquidFill(
          //   text: 'Be the Goasth',
          //   waveColor: Colors.blueAccent,
          //   boxBackgroundColor: Colors.brown.shade600,
          //   textStyle: TextStyle(
          //     fontSize: 25,
          //     fontWeight: FontWeight.bold,
          //   ),
          //   boxHeight: 70.0,
          // ),
          TableCalendar(
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2090),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
          ),
          SizedBox(height: 16),
          Text(
            'Selected Day: $_selectedDay',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _onPreviousDay,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _onNextDay,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
