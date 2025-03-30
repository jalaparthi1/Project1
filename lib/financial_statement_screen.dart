import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancialStatementScreen extends StatelessWidget {
  final List<String> expenseCategories;
  final Map<String, double> expenseData;
  final double totalIncome;
  final double totalExpenses;

  FinancialStatementScreen({
    required this.expenseCategories,
    required this.expenseData,
    required this.totalIncome,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    double remainingAmount = totalIncome - totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: Text("Financial Statement"),
        backgroundColor: Colors.teal.shade700,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Income Card
              _buildAnimatedCard(
                title: "Total Income",
                amount: totalIncome,
                color: Colors.green,
              ),
              SizedBox(height: 16),

              // Total Expenses Card
              _buildAnimatedCard(
                title: "Total Expenses",
                amount: totalExpenses,
                color: Colors.red,
              ),
              SizedBox(height: 16),

              // Remaining Amount Card
              _buildAnimatedCard(
                title: "Remaining Amount",
                amount: remainingAmount,
                color: remainingAmount >= 0 ? Colors.green : Colors.red,
              ),
              SizedBox(height: 16),

              // Pie Chart
              Text(
                "Expense Breakdown",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              _buildAnimatedPieChart(),
              SizedBox(height: 16),

              // Expense Category Breakdown
              Text(
                "Category Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              _buildAnimatedExpenseList(),
            ],
          ),
        ),
      ),
    );
  }

  // Method to create the animated financial cards (Income, Expenses, Remaining)
  Widget _buildAnimatedCard({
    required String title,
    required double amount,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Animated Pie Chart with a fade-in effect
  Widget _buildAnimatedPieChart() {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(seconds: 1),
      child: Container(
        height: 300,
        child: PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 50,
            sections: expenseCategories.map((category) {
              double categoryAmount = expenseData[category] ?? 0.0;
              double percentage = totalExpenses > 0
                  ? (categoryAmount / totalExpenses) * 100
                  : 0.0;

              return PieChartSectionData(
                value: categoryAmount,
                color: _getCategoryColor(category),
                radius: 50,
                title: '${percentage.toStringAsFixed(1)}%',
                titleStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Animated List of Expense Categories with sliding effect
  Widget _buildAnimatedExpenseList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: expenseCategories.length,
      itemBuilder: (context, index) {
        String category = expenseCategories[index];
        double categoryAmount = expenseData[category] ?? 0.0;
        double percentage =
            totalExpenses > 0 ? (categoryAmount / totalExpenses) * 100 : 0.0;

        return AnimatedSlide(
          offset: Offset(0, 0),
          duration: Duration(milliseconds: 500),
          child: Card(
            elevation: 5.0,
            shadowColor: _getCategoryColor(category).withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: _getCategoryColor(category).withOpacity(0.1),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              leading: Icon(
                Icons.category,
                color: _getCategoryColor(category),
              ),
              title: Text(
                category,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '\$${categoryAmount.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  color: _getCategoryColor(category),
                  fontSize: 16,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        );
      },
    );
  }

  // Method to determine color for each category
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Entertainment':
        return Colors.orange;
      case 'Dining':
        return Colors.green;
      case 'Grocery':
        return Colors.blue;
      case 'Rent/Utilities':
        return Colors.purple;
      case 'Shopping':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
