import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance/core/models/category.dart';
import 'package:myfinance/core/viewmodels/category_view_model.dart';
import 'package:myfinance/core/utils/icon_picker.dart';
import 'package:myfinance/core/utils/color_picker.dart';

class AddCategoryScreen extends ConsumerStatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends ConsumerState<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.category;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: _selectedColor,
              child: Icon(
                _selectedIcon,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                prefixIcon: Icon(Icons.label),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            ListTile(
              title: const Text('Select Icon'),
              trailing: Icon(_selectedIcon, color: _selectedColor),
              onTap: () async {
                final selectedIcon = await showIconPicker(context);
                if (selectedIcon != null) {
                  setState(() {
                    _selectedIcon = selectedIcon;
                  });
                }
              },
            ),
            
            ListTile(
              title: const Text('Select Color'),
              trailing: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () async {
                final selectedColor = await showColorPicker(
                  context,
                  _selectedColor,
                );
                if (selectedColor != null) {
                  setState(() {
                    _selectedColor = selectedColor;
                  });
                }
              },
            ),
            
            const SizedBox(height: 24),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _saveCategory,
              child: const Text(
                'Save Category',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final category = Category(
        name: _nameController.text.trim(),
        color: _selectedColor,
        icon: _selectedIcon,
      );
      
      ref.read(categoryViewModelProvider.notifier).addCategory(category);
      
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
} 