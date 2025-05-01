import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  final List<String> expenseCategories;

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
  void addOrUpdateBudget({int? index, required BuildContext dialogContext}) {
    final budgetAmount = double.tryParse(budgetController.text);
    final spentAmount = double.tryParse(spentController.text);

    if (selectedCategory != null &&
        budgetAmount != null &&
        spentAmount != null) {
      setState(() {
        if (index != null) {
          budgets[index] = {
            'category': selectedCategory,
            'budget': budgetAmount,
            'spent': spentAmount,
          };
        } else {
          budgets.add({
            'category': selectedCategory,
            'budget': budgetAmount,
            'spent': spentAmount,
          });
        }
      });

      Navigator.pop(dialogContext); // Close dialog
      resetInputs();
    } else {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(
          content: Text('Please enter valid values for all fields.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void resetInputs() {
    selectedCategory = null;
    budgetController.clear();
    spentController.clear();
  }

  // Dialog for adding/editing budgets
  void openAddOrEditBudgetDialog({int? index}) {
    if (index != null) {
      selectedCategory = budgets[index]['category'];
      budgetController.text = budgets[index]['budget'].toString();
      spentController.text = budgets[index]['spent'].toString();
    } else {
      resetInputs();
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(index != null ? 'Edit Budget' : 'Add Budget'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    hint: const Text('Select Category'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    items: widget.expenseCategories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Budget Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: spentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Spent Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    addOrUpdateBudget(
                        index: index, dialogContext: dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Text(index != null ? 'Update Budget' : 'Save Budget'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // UI builder for each budget item
  Widget buildBudgetCard(int index) {
    final budget = budgets[index];
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          budget['category'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Budget: \$${budget['budget']}  |  Spent: \$${budget['spent']}',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => openAddOrEditBudgetDialog(index: index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Management"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                budgets.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Budgets cleared'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
          ),
        ],
      ),
      body: budgets.isEmpty
          ? const Center(
              child: Text(
                'No budgets added yet.\nTap the + button to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) => buildBudgetCard(index),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddOrEditBudgetDialog(),
        tooltip: 'Add Budget',
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
