import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_settings_screen.dart';
import 'Budget_Saving_Screen.dart';
import 'financial_statement_screen.dart';

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
      if (isIncome) {
        incomePopUp();
      } else {
        expensePopUp();
      }
    }
  }

  void incomeUpdate(double incomeAmt) async {
    final prefs = await SharedPreferences.getInstance();
    final String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    final String incomeKey = 'income_$date';
    await prefs.setDouble(incomeKey, incomeAmt);
    await displayTransaction(date, 'Income: \$${incomeAmt.toStringAsFixed(2)}');
    setState(() {
      totalIncome = totalIncome + incomeAmt;
    });
  }

  void expenseUpdate(
      Map<String, bool> selectedCategories, double expenseAmt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    for (var entry in selectedCategories.entries) {
      if (entry.value) {
        final String expenseKey = 'expense_${entry.key}_$date';
        await prefs.setDouble(expenseKey, expenseAmt);
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
    final String transactionKey = 'transaction_$date';
    List<String> transactions = prefs.getStringList(transactionKey) ?? [];
    transactions.add(transaction);
    await prefs.setStringList(transactionKey, transactions);
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
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextField(
                  controller: income,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Income Amount"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    double incomeAmount = double.tryParse(income.text) ?? 0.0;
                    if (incomeAmount > 0) {
                      incomeUpdate(
                          incomeAmount); // Update income when user clicks Save
                      Navigator.pop(context); // Close the modal
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter a valid income amount"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: expenses,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: "Expense Amount"),
                    ),
                    SizedBox(height: 10),
                    const Text('Categories'),
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        double expenseAmount =
                            double.tryParse(expenses.text) ?? 0.0;

                        bool categorySelected = selectedCategories.values
                            .any((isSelected) => isSelected);

                        if (categorySelected) {
                          expenseUpdate(selectedCategories, expenseAmount);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Please select at least one category')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Set background color here
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12), // Padding inside button
                      ),
                      child: const Text('Save'),
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
    List<BarChartGroupData> groups = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: totalIncome,
            color: Colors.green,
            width: 20,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: totalExpenses,
            color: Colors.red,
            width: 20,
          ),
        ],
      ),
    ];
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
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
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const titles = ['Income', 'Expenses'];
                            final index = value.toInt();
                            return Text(titles[index]);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: incomePopUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Add Income'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: expensePopUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                          totalIncome: totalIncome, // Pass total income
                          totalExpenses: totalExpenses, // Pass total expenses
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Financial Statement'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.person),
      ),
    );
  }
}
