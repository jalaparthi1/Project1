import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_settings_screen.dart';
import 'BudgetScreen.dart';
import 'financial_statement_screen.dart';
import 'Savings_investments_Screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController income = TextEditingController();
  final TextEditingController expenses = TextEditingController();
  final List<String> expenseCategories = [
    'Entertainment',
    'Dining',
    'Grocery',
    'Rent/Utilities',
    'Shopping'
  ];
  final Map<String, double> expenseNames = {
    'Entertainment': 0.0,
    'Dining': 0.0,
    'Grocery': 0.0,
    'Rent/Utilities': 0.0,
    'Shopping': 0.0,
  };
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  DateTime selectedDate = DateTime.now();

  final ButtonStyle mainButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    ),
  );

  Future<void> loadBudgetData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      expenseNames['Entertainment'] =
          prefs.getDouble('EntertainmentSpent') ?? 0.0;
      expenseNames['Dining'] = prefs.getDouble('DiningSpent') ?? 0.0;
      expenseNames['Grocery'] = prefs.getDouble('GrocerySpent') ?? 0.0;
      expenseNames['Rent/Utilities'] = prefs.getDouble('RentSpent') ?? 0.0;
      expenseNames['Shopping'] = prefs.getDouble('ShoppingSpent') ?? 0.0;
      totalExpenses = expenseNames.values.reduce((a, b) => a + b);
    });
  }

  @override
  void initState() {
    super.initState();
    loadBudgetData();
  }

  Future<void> datePicker(BuildContext context, bool isIncome) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      isIncome ? incomePopUp() : expensePopUp();
    }
  }

  void incomeUpdate(double incomeAmt) async {
    final prefs = await SharedPreferences.getInstance();
    final String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    await prefs.setDouble('income_$date', incomeAmt);
    await displayTransaction(date, 'Income: \$${incomeAmt.toStringAsFixed(2)}');
    setState(() {
      totalIncome += incomeAmt;
    });
  }

  void expenseUpdate(
      Map<String, bool> selectedCategories, double expenseAmt) async {
    final prefs = await SharedPreferences.getInstance();
    final String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    for (var entry in selectedCategories.entries) {
      if (entry.value) {
        await prefs.setDouble('expense_${entry.key}_$date', expenseAmt);
        await displayTransaction(
            date, 'Expense (${entry.key}): \$${expenseAmt.toStringAsFixed(2)}');
        setState(() {
          expenseNames[entry.key] =
              (expenseNames[entry.key] ?? 0.0) + expenseAmt;
        });
      }
    }
    setState(() {
      totalExpenses = expenseNames.values.reduce((a, b) => a + b);
    });
  }

  Future<void> displayTransaction(String date, String transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'transaction_$date';
    List<String> transactions = prefs.getStringList(key) ?? [];
    transactions.add(transaction);
    await prefs.setStringList(key, transactions);
  }

  void incomePopUp() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Income Amount for ${DateFormat('yyyy-MM-dd').format(selectedDate)}:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: income,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter Income",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    double incomeAmount = double.tryParse(income.text) ?? 0.0;
                    if (incomeAmount > 0) {
                      incomeUpdate(incomeAmount);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Please enter a valid income amount")),
                      );
                    }
                  },
                  style: mainButtonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void expensePopUp() {
    Map<String, bool> selectedCategories = {
      'Entertainment': false,
      'Dining': false,
      'Grocery': false,
      'Rent/Utilities': false,
      'Shopping': false,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Expense Amount for ${DateFormat('yyyy-MM-dd').format(selectedDate)}:",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: expenses,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Enter Expense",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      'Select Categories:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Column(
                      children: expenseCategories.map((category) {
                        return CheckboxListTile(
                          title: Text(category),
                          value: selectedCategories[category],
                          onChanged: (value) {
                            setModalState(() {
                              selectedCategories[category] = value!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        double expenseAmount =
                            double.tryParse(expenses.text) ?? 0.0;
                        bool categorySelected =
                            selectedCategories.containsValue(true);

                        if (categorySelected && expenseAmount > 0) {
                          expenseUpdate(selectedCategories, expenseAmount);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Enter amount & select at least one category')),
                          );
                        }
                      },
                      style: mainButtonStyle.copyWith(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: const Text('Save Expense'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<BarChartGroupData> barGroups() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(toY: totalIncome, color: Colors.green, width: 20)
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: totalExpenses, color: Colors.red, width: 20)
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1000,
                  barGroups: barGroups(),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['Income', 'Expenses'];
                          return Text(titles[value.toInt()],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: incomePopUp,
                  style: mainButtonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: const Text('Add Income'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: expensePopUp,
                  style: mainButtonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text('Add Expense'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BudgetScreen(
                            expenseCategories: expenseCategories,
                          ),
                        ));
                  },
                  style: mainButtonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: const Text('Manage Budget'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FinancialStatementScreen(
                            expenseCategories: expenseCategories,
                            expenseData: expenseNames,
                            totalIncome: totalIncome,
                            totalExpenses: totalExpenses,
                          ),
                        ));
                  },
                  style: mainButtonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: const Text('Financial'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.person),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 80,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavingsScreen(
                      income: totalIncome,
                      expenditure: totalExpenses,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.savings),
            ),
          ),
        ],
      ),
    );
  }
}
