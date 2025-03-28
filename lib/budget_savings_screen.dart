import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  final double totalIncome;
  final double totalExpenses;
  final Map<String, double> expenseCategories;

  // Constructor to accept data from HomeScreen
  BudgetScreen({
    required this.totalIncome,
    required this.totalExpenses,
    required this.expenseCategories,
  });

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late double totalIncome;
  late double totalExpenses;
  late Map<String, double> expenseCategories;

  @override
  void initState() {
    super.initState();
    totalIncome = widget.totalIncome; // Initialize from widget data
    totalExpenses = widget.totalExpenses; // Initialize from widget data
    expenseCategories =
        widget.expenseCategories; // Initialize expense categories
  }

  // Function to handle updating an expense category
  void _updateExpenseCategory(String category, double amount) {
    setState(() {
      expenseCategories[category] = amount;
      totalExpenses = expenseCategories.values
          .fold(0, (sum, value) => sum + value); // Recalculate total expenses
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Management'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Income: \$${totalIncome.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Total Expenses: \$${totalExpenses.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Expense Categories:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Display expense categories and allow editing
            ...expenseCategories.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                trailing: Text('\$${entry.value.toStringAsFixed(2)}'),
                onTap: () async {
                  double? newAmount =
                      await _showEditDialog(context, entry.key, entry.value);
                  if (newAmount != null) {
                    _updateExpenseCategory(entry.key, newAmount);
                  }
                },
              );
            }).toList(),
            SizedBox(height: 16),
            Text(
              'Remaining Budget: \$${(totalIncome - totalExpenses).toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to edit an expense category
  Future<double?> _showEditDialog(
      BuildContext context, String category, double currentAmount) {
    TextEditingController _controller =
        TextEditingController(text: currentAmount.toString());

    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $category'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Amount'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double? newAmount = double.tryParse(_controller.text);
                if (newAmount != null && newAmount >= 0) {
                  Navigator.of(context)
                      .pop(newAmount); // Pass the new amount back to update
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
