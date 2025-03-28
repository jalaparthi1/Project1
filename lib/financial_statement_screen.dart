import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class FinancialStatementScreen extends StatefulWidget {
  @override
  _FinancialStatementScreenState createState() =>
      _FinancialStatementScreenState();
}

class _FinancialStatementScreenState extends State<FinancialStatementScreen> {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> transactions = {
    DateTime(2025, 3, 20): ["Salary: +\$2000", "Groceries: -\$150"],
    DateTime(2025, 3, 21): ["Electricity Bill: -\$80"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Financial Statement"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // This will take the user back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
          ),
          Expanded(
            child: ListView(
              children: (transactions[_selectedDay] ?? [])
                  .map((transaction) => ListTile(title: Text(transaction)))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
