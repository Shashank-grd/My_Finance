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
    final categories = await _repository.getAllCategories();
    state = categories;
  }
  
  Future<void> addCategory(Category category) async {
    await _repository.saveCategory(category);
    await loadCategories();
  }
  
  Future<void> updateCategory(Category category) async {
    await _repository.saveCategory(category);
    await loadCategories();
  }
  
  Future<void> deleteCategory(String id) async {
    await _repository.deleteCategory(id);
    await loadCategories();
  }
  
  Category? getCategoryById(String id) {
    try {
      return state.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
} 