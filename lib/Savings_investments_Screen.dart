import 'package:flutter/material.dart';

class SavingsScreen extends StatefulWidget {
  final double income;
  final double expenditure;

  SavingsScreen({required this.income, required this.expenditure});

  @override
  _SavingsScreenState createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  double savings = 0.0;
  List<String> selectedStocks = [];
  Map<String, double> stockPrices = {
    'AAPL': 2.30, // Apple
    'GOOGL': 5.00, // Google
    'AMZN': 10.00, // Amazon
    'MSFT': 3.50, // Microsoft
    'TSLA': 5.00, // Tesla
    'META': 8.00, // Meta
    'NFLX': 12.00, // Netflix
    'SPY': 7.50, // S&P 500 ETF
  };
  double totalInvestment = 0.0;

  @override
  void initState() {
    super.initState();
    savings = widget.income - widget.expenditure;
  }

  void _showStockSelectionDialog() {
    List<String> tempSelectedStocks = List.from(selectedStocks);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Stocks to Invest in"),
          content: SingleChildScrollView(
            child: Column(
              children: stockPrices.keys.map((stock) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return CheckboxListTile(
                      title: Text('$stock - \$${stockPrices[stock]}'),
                      value: tempSelectedStocks.contains(stock),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelectedStocks.add(stock);
                          } else {
                            tempSelectedStocks.remove(stock);
                          }
                        });
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Update selected stocks
                  selectedStocks = List.from(tempSelectedStocks);

                  // Calculate the total investment
                  totalInvestment = 0.0;
                  selectedStocks.forEach((stock) {
                    totalInvestment += stockPrices[stock]!;
                  });

                  // Deduct investment from savings
                  savings -= totalInvestment;
                });

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Invest"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Savings & Investment'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Total Savings: \$${savings.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showStockSelectionDialog,
              child: Text('Invest in Stocks'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Stocks for Investment:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            selectedStocks.isEmpty
                ? Text("No stocks selected", style: TextStyle(fontSize: 16))
                : Column(
                    children: selectedStocks.map((stock) {
                      return ListTile(
                        title: Text('$stock - \$${stockPrices[stock]}'),
                        leading: Icon(Icons.trending_up),
                      );
                    }).toList(),
                  ),
            SizedBox(height: 20),
            Text(
              'Total Investment in Stocks: \$${totalInvestment.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
