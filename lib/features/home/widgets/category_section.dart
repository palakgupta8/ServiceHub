import 'package:flutter/material.dart';
import '../../../shared/models/service_category_model.dart';
import '../../../core/theme/app_text_styles.dart';

class CategorySection extends StatelessWidget {
  final List<ServiceCategoryModel> categories;
  final void Function(ServiceCategoryModel) onCategoryTapped;

  const CategorySection({
    super.key,
    required this.categories,
    required this.onCategoryTapped,
  });

  @override
  Widget build(BuildContext context) {
    // SizedBox with fixed height + ListView.builder (horizontal)
    // This is the correct pattern for a horizontal scrollable list
    // DO NOT use Row — Row doesn't scroll and crashes with overflow
    return SizedBox(
      height: 96,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,  // horizontal scroll
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _CategoryTile(
            category: categories[index],
            onTap: () => onCategoryTapped(categories[index]),
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final ServiceCategoryModel category;
  final VoidCallback onTap;

  const _CategoryTile({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: category.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                category.icon,
                size: 28,
                color: category.iconColor,
              ),
            ),
            const SizedBox(height: 8),
            // Category name — overflow handled with ellipsis
            Text(
              category.name,
              style: AppTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
