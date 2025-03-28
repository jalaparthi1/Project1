import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_settings_screen.dart'; // Import the ProfileScreen
import 'Budget_Saving_Screen.dart'; // Import the BudgetScreen
import 'financial_statement_screen.dart'; // Import the FinancialStatementScreen

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

  // Load budget and spent data from SharedPreferences
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
    loadBudgetData(); // Load the budget data when the home screen is loaded
  }

  void incomeUpdate(double incomeAmt) {
    setState(() {
      totalIncome = totalIncome + incomeAmt;
    });
  }

  void expenseUpdate(
      Map<String, bool> selectedCategories, double expenseAmt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCategories.forEach((category, isSelected) {
        if (isSelected) {
          expenseNames[category] = (expenseNames[category] ?? 0.0) + expenseAmt;
          // Save the updated spent amount in SharedPreferences
          prefs.setDouble('${category}Spent', expenseNames[category]!);
        }
      });

      // Recalculate total expenses
      totalExpenses = expenseNames.values.reduce((a, b) => a + b);
    });
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
                const Text("Income Amount: ",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextField(
                  controller: income,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Income Amount"),
                  onChanged: (value) {
                    double incomeAmount = double.tryParse(value) ?? 0.0;
                    incomeUpdate(incomeAmount);
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                    const Text(
                      'Expense Details: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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
                  child: const Text('Add Income'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: expensePopUp,
                  child: const Text('Add Expense'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: const Text('Profile Settings'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BudgetScreen(
                              expenseCategories: expenseCategories)),
                    );
                  },
                  child: const Text('Manage Budget'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FinancialStatementScreen()),
                    );
                  },
                  child: const Text('Financial Statement'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
