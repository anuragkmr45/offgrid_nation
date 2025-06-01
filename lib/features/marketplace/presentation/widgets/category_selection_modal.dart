// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:offgrid_nation_app/features/marketplace/domain/entities/category_entity.dart';

// class CategorySelectionModal extends StatelessWidget {
//   final List<CategoryEntity> categories;
//   final Future<void> Function(String categoryId) onCategorySelected;

//   const CategorySelectionModal({
//     super.key,
//     required this.categories,
//     required this.onCategorySelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.95,
//       minChildSize: 0.8,
//       maxChildSize: 0.95,
//       builder: (_, controller) => Container(
//         padding: const EdgeInsets.only(top: 24),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: CupertinoSearchTextField(
//                 placeholder: 'Search',
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Divider(height: 0),
//             Expanded(
//               child: ListView.separated(
//                 controller: controller,
//                 itemCount: categories.length,
//                 separatorBuilder: (_, __) => const Divider(height: 0),
//                 itemBuilder: (context, index) {
//                   final category = categories[index];
//                   return ListTile(
//                     leading: const Icon(Icons.circle_outlined, size: 20),
//                     title: Text(category.title),
//                     onTap: () async {
//                       Navigator.pop(context, category.id); // Close the modal first

//                       // Show loader
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (_) => const Center(child: CircularProgressIndicator()),
//                       );

//                       await onCategorySelected(category.id);

//                       if (context.mounted) Navigator.pop(context); // Close loader
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/category_entity.dart';

class CategorySelectionModal extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CategorySelectionModal({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.only(top: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSearchTextField(
                placeholder: 'Search',
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 0),
            Expanded(
              child: ListView.separated(
                controller: controller,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    leading: const Icon(Icons.circle_outlined, size: 20),
                    title: Text(category.title),
                    onTap: () {
                      Navigator.pop(context, category.id); // ✅ Return selected ID
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
