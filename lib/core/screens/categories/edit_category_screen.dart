import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance/core/models/category.dart';
import 'package:myfinance/core/viewmodels/category_view_model.dart';
import 'package:myfinance/core/utils/icon_picker.dart';
import 'package:myfinance/core/utils/color_picker.dart';

class EditCategoryScreen extends ConsumerStatefulWidget {
  final Category category;

  const EditCategoryScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  ConsumerState<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends ConsumerState<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  late Color _selectedColor;
  late IconData _selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _selectedColor = widget.category.color;
    _selectedIcon = widget.category.icon;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ],
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
              onPressed: _updateCategory,
              child: const Text(
                'Update Category',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateCategory() {
    if (_formKey.currentState!.validate()) {
      final updatedCategory = widget.category.copyWith(
        name: _nameController.text.trim(),
        color: _selectedColor,
        icon: _selectedIcon,
      );
      
      ref.read(categoryViewModelProvider.notifier).updateCategory(updatedCategory);
      
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this category? This will affect all associated transactions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(categoryViewModelProvider.notifier)
                  .deleteCategory(widget.category.id);
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Category deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}