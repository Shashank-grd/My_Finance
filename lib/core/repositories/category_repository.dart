import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/core/models/category.dart';
import 'package:myfinance/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String? get _userId => _auth.currentUser?.uid;
  
  Future<List<Category>> getAllCategories() async {
    if (_userId == null) {
      return _getDefaultCategories();
    }
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('categories')
          .get();
      
      final categories = snapshot.docs
          .map((doc) => Category.fromJson(doc.data()))
          .toList();
      
      // Return default categories if none exist
      if (categories.isEmpty) {
        final defaults = _getDefaultCategories();
        // Save default categories to Firestore
        for (var category in defaults) {
          await saveCategory(category);
        }
        return defaults;
      }
      
      return categories;
    } catch (e) {
      print('Error getting categories: $e');
      return _getDefaultCategories();
    }
  }

  Future<void> saveCategory(Category category) async {
    if (_userId == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('categories')
          .doc(category.id)
          .set(category.toJson());
    } catch (e) {
      print('Error saving category: $e');
      throw Exception('Failed to save category');
    }
  }

  Future<void> deleteCategory(String id) async {
    if (_userId == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('categories')
          .doc(id)
          .delete();
    } catch (e) {
      print('Error deleting category: $e');
      throw Exception('Failed to delete category');
    }
  }

  List<Category> _getDefaultCategories() {
    return [
      Category(
        name: 'Groceries',
        color: Colors.green,
        icon: Icons.shopping_cart,
      ),
      Category(
        name: 'Transportation',
        color: Colors.blue,
        icon: Icons.directions_car,
      ),
      Category(
        name: 'Entertainment',
        color: Colors.purple,
        icon: Icons.movie,
      ),
      Category(
        name: 'Dining',
        color: Colors.orange,
        icon: Icons.restaurant,
      ),
      Category(
        name: 'Salary',
        color: Colors.teal,
        icon: Icons.work,
      ),
      Category(
        name: 'Housing',
        color: Colors.brown,
        icon: Icons.home,
      ),
    ];
  }
} 