import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance/core/models/category.dart';
import 'package:myfinance/core/services/auth_service.dart';
import 'package:myfinance/core/Models/transaction.dart' as Ts;
final syncServiceProvider = Provider<SyncService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SyncService(authService);
});

class SyncService {
  final AuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  SyncService(this._authService);
  
  String? get _userId => _authService.currentUser?.uid;
  
  Future<void> syncTransactions(List<Ts.Transaction> transactions) async {
    if (_userId == null) return;
    
    final batch = _firestore.batch();
    final userTransactionsRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('transactions');
    
    // First get existing transactions from Firestore
    final existingDocs = await userTransactionsRef.get();
    final existingIds = existingDocs.docs.map((doc) => doc.id).toSet();
    final localIds = transactions.map((t) => t.id).toSet();
    
    // Delete transactions that exist in Firestore but not locally
    for (final doc in existingDocs.docs) {
      if (!localIds.contains(doc.id)) {
        batch.delete(userTransactionsRef.doc(doc.id));
      }
    }
    
    // Update or add local transactions
    for (final transaction in transactions) {
      batch.set(
        userTransactionsRef.doc(transaction.id),
        transaction.toJson(),
        SetOptions(merge: true),
      );
    }
    
    await batch.commit();
  }
  
  Future<void> syncCategories(List<Category> categories) async {
    if (_userId == null) return;
    
    final batch = _firestore.batch();
    final userCategoriesRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('categories');
    
    // First get existing categories from Firestore
    final existingDocs = await userCategoriesRef.get();
    final existingIds = existingDocs.docs.map((doc) => doc.id).toSet();
    final localIds = categories.map((t) => t.id).toSet();
    
    // Delete categories that exist in Firestore but not locally
    for (final doc in existingDocs.docs) {
      if (!localIds.contains(doc.id)) {
        batch.delete(userCategoriesRef.doc(doc.id));
      }
    }
    
    // Update or add local categories
    for (final category in categories) {
      batch.set(
        userCategoriesRef.doc(category.id),
        category.toJson(),
        SetOptions(merge: true),
      );
    }
    
    await batch.commit();
  }
  
  Future<List<Ts.Transaction>> fetchTransactions() async {
    if (_userId == null) return [];
    
    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('transactions')
        .get();
    
    return snapshot.docs
        .map((doc) => Ts.Transaction.fromJson(doc.data()))
        .toList();
  }
  
  Future<List<Category>> fetchCategories() async {
    if (_userId == null) return [];
    
    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('categories')
        .get();
    
    return snapshot.docs
        .map((doc) => Category.fromJson(doc.data()))
        .toList();
  }
} 