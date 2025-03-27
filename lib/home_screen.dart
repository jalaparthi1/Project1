import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

  void incomeUpdate(double incomeAmt) {
    setState(() {
      totalIncome = totalIncome + incomeAmt;
    });
  }

  void expenseUpdate(Map<String, bool> selectedCategories, double expenseAmt) {
    setState(() {
      selectedCategories.forEach((category, isSelected) {
        if (isSelected) {
          expenseNames[category] = (expenseNames[category] ?? 0.0) + expenseAmt;
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: income,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: "Income Amount"),
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
                )),
          );
        });
  }

  void expensePopUp() {
    // Create a mutable state for selected categories
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
                        
                        // Check if at least one category is selected
                        bool categorySelected = 
                            selectedCategories.values.any((isSelected) => isSelected);
                        
                        if (categorySelected) {
                          expenseUpdate(selectedCategories, expenseAmount); 
                          Navigator.pop(context);
                        } else {
                          // Show an error if no category is selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select at least one category')),
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
      // Income bar
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
      // Collective Expenses bar
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
                height: 300, // Explicit height
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}