import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class FinancialStatementScreen extends StatefulWidget {
  @override
  _FinancialStatementScreenState createState() =>
      _FinancialStatementScreenState();
}

class _FinancialStatementScreenState extends State<FinancialStatementScreen> {
  DateTime _selectedDay = DateTime.now();
  Map<String, List<String>> transactions = {};

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      transactions.clear();
      for (var key in prefs.getKeys()) {
        if (key.startsWith('transaction_')) {
          List<String> listOfTransactions = prefs.getStringList(key) ?? [];
          transactions[key] = listOfTransactions;
        }
      }
    });
  }

  List<String> getTransactionsForSelectedDate() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
    List<String> selectedDateTransactions = [];

    transactions.forEach((key, value) {
      if (key.contains(formattedDate)) {
        selectedDateTransactions.addAll(value);
      }
    });

    return selectedDateTransactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Financial Statement"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: loadTransactions,
          ),
        ],
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Transactions for ${DateFormat('yyyy-MM-dd').format(_selectedDay)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: getTransactionsForSelectedDate()
                  .map((transaction) => ListTile(title: Text(transaction)))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
