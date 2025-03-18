import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:myfinance/core/models/transaction.dart';

class TransactionRepository {
  static const String _transactionsKey = 'transactions';

  Future<List<Transaction>> getAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
    
    return transactionsJson
        .map((json) => Transaction.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveTransaction(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getAllTransactions();
    
    final existingIndex = transactions.indexWhere((t) => t.id == transaction.id);
    
    if (existingIndex >= 0) {
      transactions[existingIndex] = transaction;
    } else {
      transactions.add(transaction);
    }
    
    final transactionsJson = transactions
        .map((transaction) => jsonEncode(transaction.toJson()))
        .toList();
    
    await prefs.setStringList(_transactionsKey, transactionsJson);
  }

  Future<void> deleteTransaction(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getAllTransactions();
    
    transactions.removeWhere((transaction) => transaction.id == id);
    
    final transactionsJson = transactions
        .map((transaction) => jsonEncode(transaction.toJson()))
        .toList();
    
    await prefs.setStringList(_transactionsKey, transactionsJson);
  }
} 