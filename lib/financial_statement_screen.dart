import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancialStatementScreen extends StatelessWidget {
  final List<String> expenseCategories;
  final Map<String, double> expenseData;
  final double totalIncome;
  final double totalExpenses;

  const FinancialStatementScreen({
    Key? key,
    required this.expenseCategories,
    required this.expenseData,
    required this.totalIncome,
    required this.totalExpenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double remainingAmount = totalIncome - totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Financial Statement"),
        backgroundColor: Colors.teal.shade700,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedCard(
                title: "Total Income",
                amount: totalIncome,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildAnimatedCard(
                title: "Total Expenses",
                amount: totalExpenses,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              _buildAnimatedCard(
                title: "Remaining Amount",
                amount: remainingAmount,
                color: remainingAmount >= 0 ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Expense Breakdown"),
              const SizedBox(height: 16),
              _buildAnimatedPieChart(),
              const SizedBox(height: 32),
              _buildSectionTitle("Category Details"),
              const SizedBox(height: 16),
              _buildAnimatedExpenseList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildAnimatedCard({
    required String title,
    required double amount,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedPieChart() {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(seconds: 1),
      child: SizedBox(
        height: 300,
        child: PieChart(
          PieChartData(
            centerSpaceRadius: 45,
            sectionsSpace: 2,
            sections: expenseCategories.map((category) {
              final double value = expenseData[category] ?? 0.0;
              final double percentage =
                  totalExpenses > 0 ? (value / totalExpenses) * 100 : 0.0;

              return PieChartSectionData(
                value: value,
                color: _getCategoryColor(category),
                radius: 60,
                title: '${percentage.toStringAsFixed(1)}%',
                titleStyle: const TextStyle(
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

  Widget _buildAnimatedExpenseList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: expenseCategories.length,
      itemBuilder: (context, index) {
        final category = expenseCategories[index];
        final amount = expenseData[category] ?? 0.0;
        final percentage =
            totalExpenses > 0 ? (amount / totalExpenses) * 100 : 0.0;
        final color = _getCategoryColor(category);

        return AnimatedSlide(
          offset: const Offset(0, 0),
          duration: const Duration(milliseconds: 500),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: color.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.label, color: color),
              title: Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "\$${amount.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)",
                style: TextStyle(color: color),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'entertainment':
        return Colors.orange;
      case 'dining':
        return Colors.green;
      case 'grocery':
        return Colors.blue;
      case 'rent/utilities':
        return Colors.purple;
      case 'shopping':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
