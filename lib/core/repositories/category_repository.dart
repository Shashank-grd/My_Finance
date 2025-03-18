import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myfinance/core/models/category.dart';

class CategoryRepository {
  static const String _categoriesKey = 'categories';

  Future<List<Category>> getAllCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = prefs.getStringList(_categoriesKey);
    
    if (categoriesJson == null || categoriesJson.isEmpty) {
      // Return default categories if none exist
      return _getDefaultCategories();
    }
    
    return categoriesJson
        .map((json) => Category.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveCategory(Category category) async {
    final prefs = await SharedPreferences.getInstance();
    final categories = await getAllCategories();
    
    final existingIndex = categories.indexWhere((c) => c.id == category.id);
    
    if (existingIndex >= 0) {
      categories[existingIndex] = category;
    } else {
      categories.add(category);
    }
    
    final categoriesJson = categories
        .map((category) => jsonEncode(category.toJson()))
        .toList();
    
    await prefs.setStringList(_categoriesKey, categoriesJson);
  }

  Future<void> deleteCategory(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final categories = await getAllCategories();
    
    categories.removeWhere((category) => category.id == id);
    
    final categoriesJson = categories
        .map((category) => jsonEncode(category.toJson()))
        .toList();
    
    await prefs.setStringList(_categoriesKey, categoriesJson);
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