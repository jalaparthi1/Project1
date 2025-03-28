import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  final List<String> expenseCategories;

  // Constructor accepting expenseCategories as a parameter
  BudgetScreen({required this.expenseCategories});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController spentController = TextEditingController();
  String? selectedCategory;
  List<Map<String, dynamic>> budgets = [];

  // Function to add or update a budget
  void addOrUpdateBudget({int? index}) {
    final budgetAmount = double.tryParse(budgetController.text);
    final spentAmount = double.tryParse(spentController.text);

    if (selectedCategory != null &&
        budgetAmount != null &&
        spentAmount != null) {
      setState(() {
        if (index != null) {
          // Update existing budget
          budgets[index] = {
            'category': selectedCategory,
            'budget': budgetAmount,
            'spent': spentAmount,
          };
        } else {
          // Add new budget
          budgets.add({
            'category': selectedCategory,
            'budget': budgetAmount,
            'spent': spentAmount,
          });
        }
        // Reset the inputs and category after adding/updating
        selectedCategory = null;
        budgetController.clear();
        spentController.clear();
      });
    }
  }

  // Function to open a dialog to add or edit a budget
  void openAddOrEditBudgetDialog({int? index}) {
    if (index != null) {
      // If index is provided, this means we are editing an existing budget
      selectedCategory = budgets[index]['category'];
      budgetController.text = budgets[index]['budget'].toString();
      spentController.text = budgets[index]['spent'].toString();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index != null ? 'Edit Budget' : 'Add Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                hint: const Text('Select Expense Category'),
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                items: widget.expenseCategories
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
              ),
              TextField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Budget Amount'),
              ),
              TextField(
                controller: spentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Spent Amount'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                addOrUpdateBudget(index: index);
                Navigator.pop(context); // Close the dialog after saving
              },
              child: Text(index != null ? 'Update Budget' : 'Save Budget'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Budget Management")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display added budgets
            Expanded(
              child: ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  final budget = budgets[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(budget['category']),
                      subtitle: Text(
                          'Budget: \$${budget['budget']} | Spent: \$${budget['spent']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Open the dialog to edit the selected budget
                          openAddOrEditBudgetDialog(index: index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Add "+" button in the bottom-right corner
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open the dialog to add a new budget
          openAddOrEditBudgetDialog();
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Budget',
      ),
    );
  }
}
