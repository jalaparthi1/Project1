import 'package:flutter/material.dart';

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
  final Map<String, bool> selectedExpeseCategory = {
    'Entertainment': false,
    'Dining': false,
    'Grocery': false,
    'Rent/Utilities': false,
    'Shopping': false,
  };

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
                      children: expenseCategories.map((expenseCategories) {
                        return CheckboxListTile(
                          title: Text(expenseCategories),
                          value: selectedExpeseCategory[expenseCategories],
                          onChanged: (value) {
                            setModalState(() {
                              selectedExpeseCategory[expenseCategories] =
                                  value!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context){ 
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: incomePopUp,
              child: const Text('Add Income'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: expensePopUp,
              child: const Text('Add Expense'),
            )
          ],
        ),
      ),
    );
  }
}
