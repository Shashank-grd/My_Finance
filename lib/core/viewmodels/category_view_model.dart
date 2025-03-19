import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance/core/models/category.dart';
import 'package:myfinance/core/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final categoryViewModelProvider = StateNotifierProvider<CategoryViewModel, List<Category>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryViewModel(repository);
});

class CategoryViewModel extends StateNotifier<List<Category>> {
  final CategoryRepository _repository;
  
  CategoryViewModel(this._repository) : super([]) {
    loadCategories();
  }
  
  Future<void> loadCategories() async {
    try {
      final categories = await _repository.getAllCategories();
      state = categories;
    } catch (e) {
      print('Error loading categories: $e');
      // Handle error - could show a message to user
    }
  }
  
  Future<void> addCategory(Category category) async {
    try {
      await _repository.saveCategory(category);
      await loadCategories();
    } catch (e) {
      print('Error adding category: $e');
      // Handle error - could show a message to user
    }
  }
  
  Future<void> updateCategory(Category category) async {
    try {
      await _repository.saveCategory(category);
      await loadCategories();
    } catch (e) {
      print('Error updating category: $e');
      // Handle error - could show a message to user
    }
  }
  
  Future<void> deleteCategory(String id) async {
    try {
      await _repository.deleteCategory(id);
      await loadCategories();
    } catch (e) {
      print('Error deleting category: $e');
      // Handle error - could show a message to user
    }
  }
  
  Category? getCategoryById(String id) {
    try {
      return state.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
} 