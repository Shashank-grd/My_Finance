import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myfinance/core/viewmodels/transaction_view_model.dart';
import 'package:myfinance/core/viewmodels/category_view_model.dart';

class SpendingChart extends ConsumerWidget {
  const SpendingChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorySpending = ref.watch(transactionViewModelProvider.notifier).getCategorySpending();
    final categories = ref.watch(categoryViewModelProvider);
    
    if (categorySpending.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No expense data to display',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Filter out categories with zero spending
    final validCategories = categorySpending.entries
        .where((entry) => entry.value > 0)
        .map((entry) {
          final category = categories.firstWhere(
            (cat) => cat.id == entry.key,
            orElse: () => categories.first,
          );
          return MapEntry(category, entry.value);
        })
        .toList();

    // Calculate total spending
    final totalSpending = validCategories.fold<double>(
      0, (sum, entry) => sum + entry.value);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: validCategories.map((entry) {
                final category = entry.key;
                final amount = entry.value;
                final percentage = (amount / totalSpending * 100).toStringAsFixed(1);
                
                return PieChartSectionData(
                  color: category.color,
                  value: amount,
                  title: '$percentage%',
                  radius: 80,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: validCategories.length,
            itemBuilder: (context, index) {
              final entry = validCategories[index];
              final category = entry.key;
              final amount = entry.value;
              final percentage = (amount / totalSpending * 100).toStringAsFixed(1);
              
              return ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: category.color,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '\$${amount.toStringAsFixed(2)} ($percentage%)',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 