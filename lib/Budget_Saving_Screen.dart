import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  List<Map<String, dynamic>> budgets = [];

  void addBudget() {
    setState(() {
      budgets.add({
        'category': categoryController.text,
        'amount': double.parse(budgetController.text),
      });
      categoryController.clear();
      budgetController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Budget Management")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: "Expense Category"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: budgetController,
              decoration: InputDecoration(labelText: "Budget Amount"),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: addBudget,
            child: Text("Add Budget"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(budgets[index]['category']),
                  subtitle: Text("\$${budgets[index]['amount']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
