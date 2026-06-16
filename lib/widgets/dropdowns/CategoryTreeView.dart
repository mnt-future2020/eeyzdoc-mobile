import 'package:flutter/material.dart';

import '../../data/models/response/CategoryDropDownResponse.dart';

class CategoryTreeView extends StatelessWidget {
  final List<CategoryDropdownResponse> categories;
  final Function(CategoryDropdownResponse) onSelected;
  final String? selectedCategoryId;

  const CategoryTreeView({
    super.key,
    required this.categories,
    required this.onSelected,
    this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: categories.map((cat) => _buildCategory(context,cat)).toList(),
    );
  }

  Widget _buildCategory(BuildContext context, CategoryDropdownResponse category) {
    final theme = Theme.of(context);
    final isSelected = category.id == selectedCategoryId;

    if (category.children.isEmpty) {
      return ListTile(
        title: Text(
          category.name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.textTheme.bodyMedium?.color,
          ),
        ),
        trailing: isSelected
            ? Icon(
          Icons.check_circle,
          color: theme.colorScheme.primary,
          size: 18,
        )
            : null,
        onTap: () => onSelected(category),
      );
    }

    final shouldExpand = _containsSelected(category, selectedCategoryId);

    return ExpansionTile(
      initiallyExpanded: shouldExpand,
      iconColor: theme.colorScheme.primary,
      collapsedIconColor: theme.iconTheme.color,
      title: Text(
        category.name,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.textTheme.bodyMedium?.color,
        ),
      ),
      children: category.children
          .map((child) => _buildCategory(context, child))
          .toList(),
    );
  }

  bool _containsSelected(CategoryDropdownResponse category, String? selectedId) {
    if (selectedId == null) return false;
    if (category.id == selectedId) return true;

    for (var child in category.children) {
      if (_containsSelected(child, selectedId)) return true;
    }

    return false;
  }
}
