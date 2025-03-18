import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance/core/models/transaction.dart';
import 'package:myfinance/core/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

final transactionViewModelProvider = StateNotifierProvider<TransactionViewModel, List<Transaction>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionViewModel(repository);
});

class TransactionViewModel extends StateNotifier<List<Transaction>> {
  final TransactionRepository _repository;
  
  TransactionViewModel(this._repository) : super([]) {
    loadTransactions();
  }
  
  Future<void> loadTransactions() async {
    final transactions = await _repository.getAllTransactions();
    state = transactions;
  }
  
  Future<void> addTransaction(Transaction transaction) async {
    await _repository.saveTransaction(transaction);
    await loadTransactions();
  }
  
  Future<void> updateTransaction(Transaction transaction) async {
    await _repository.saveTransaction(transaction);
    await loadTransactions();
  }
  
  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    await loadTransactions();
  }
  
  double getTotalIncome() {
    return state
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }
  
  double getTotalExpenses() {
    return state
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }
  
  double getBalance() {
    return getTotalIncome() - getTotalExpenses();
  }
  
  Map<String, double> getCategorySpending() {
    final Map<String, double> result = {};
    
    for (final transaction in state.where((t) => t.type == TransactionType.expense)) {
      result[transaction.categoryId] = (result[transaction.categoryId] ?? 0) + transaction.amount;
    }
    
    return result;
  }
} 