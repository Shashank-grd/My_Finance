import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance/core/screens/transactions/transaction_list_screen.dart';
import 'package:myfinance/core/screens/transactions/add_transaction_screen.dart';
import 'package:myfinance/core/screens/categories/categories_screen.dart';
import 'package:myfinance/core/viewmodels/transaction_view_model.dart';
import 'package:myfinance/core/widgets/spending_chart.dart';
import 'package:myfinance/core/services/notification_service.dart';
import 'package:myfinance/core/models/transaction.dart' as Ts;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionListScreen(),
    const CategoriesScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyFinance"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Navigate to profile/settings
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionData = ref.watch(transactionViewModelProvider);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Financial Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildSummaryCard(context,ref),
          const SizedBox(height: 24),
          const Text(
            'Spending by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SpendingChart(),
          ),
          ElevatedButton(
            onPressed: () async {
              final notificationService = ref.read(notificationServiceProvider);

              // Send an immediate test notification
              await notificationService.enableNotificationLogging();

              // Create a test transaction with current timestamp
              final testTransaction = Ts.Transaction(
                title: "Test Direct Notification",
                amount: 25.0,
                type: Ts.TransactionType.expense,
                categoryId: "31f912d4-278d-41f8-a4ec-a9348fa762f1",
                date: DateTime.now(),
              );

              // Schedule it
              await notificationService.scheduleRecurringNotification(
                transaction: testTransaction,
                recurringPeriod: 'Daily',
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Test notification sent! Check your device notifications'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Test Notification Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context,WidgetRef ref) {
    final totalIncome = ref.watch(transactionViewModelProvider.notifier).getTotalIncome();
    final totalExpenses = ref.watch(transactionViewModelProvider.notifier).getTotalExpenses();
    final balance = ref.watch(transactionViewModelProvider.notifier).getBalance();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
              'Income',
              '\$${totalIncome.toStringAsFixed(2)}',
              Colors.green,
            ),
            _buildSummaryItem(
              'Expenses',
              '\$${totalExpenses.toStringAsFixed(2)}',
              Colors.red,
            ),
            _buildSummaryItem(
              'Balance',
              '\$${balance.toStringAsFixed(2)}',
              balance >= 0 ? Colors.blue : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String amount, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}