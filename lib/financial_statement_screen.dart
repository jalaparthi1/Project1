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

  // Function to load transactions from SharedPreferences
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

  // Function to get transactions for the selected date
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

  // Function to add transaction to SharedPreferences
  Future<void> addTransaction(String transaction) async {
    final prefs = await SharedPreferences.getInstance();

    // Get formatted date
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);

    // Get existing transactions for that date
    String transactionKey = 'transaction_$formattedDate';
    List<String> existingTransactions =
        prefs.getStringList(transactionKey) ?? [];

    // Add new transaction
    existingTransactions.add(transaction);

    // Save the updated list of transactions
    await prefs.setStringList(transactionKey, existingTransactions);

    // Reload transactions
    loadTransactions();
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Transactions for ${DateFormat('yyyy-MM-dd').format(_selectedDay)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ListView(
                children: getTransactionsForSelectedDate()
                    .map((transaction) => Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                              transaction,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
