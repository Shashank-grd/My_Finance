import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfinance/core/models/transaction.dart' as Ts;

class TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String? get _userId => _auth.currentUser?.uid;

  Future<List<Ts.Transaction>> getAllTransactions() async {
    if (_userId == null) return [];
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Ts.Transaction.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting transactions: $e');
      return [];
    }
  }

  Future<void> saveTransaction(Ts.Transaction transaction) async {
    if (_userId == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toJson());
    } catch (e) {
      print('Error saving transaction: $e');
      throw Exception('Failed to save transaction');
    }
  }

  Future<void> deleteTransaction(String id) async {
    if (_userId == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('transactions')
          .doc(id)
          .delete();
    } catch (e) {
      print('Error deleting transaction: $e');
      throw Exception('Failed to delete transaction');
    }
  }
} 