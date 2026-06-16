import 'package:docuflow/data/models/response/user_dropdown_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/documents/controllers/documents_controller.dart';
import '../../data/models/response/dropdown_response.dart';

class SearchableUsersDropdown extends StatelessWidget {
  const SearchableUsersDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();

    return Obx(() {
      final query = controller.userSearchController.text.toLowerCase();
      final filteredUsers = controller.usersList.where((user) {
        final matches = user.email?.toLowerCase().contains(query) ?? false;
        return matches && !controller.isUserSelected(user.id!);
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.userSearchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => controller.showUserDropdown.value = true,
            onTap: () => controller.showUserDropdown.value = true,
          ),

          if (controller.showUserDropdown.value && filteredUsers.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 8,
                      offset: Offset(0, 4)
                  )
                ],
              ),
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (_, index) {
                  final user = filteredUsers[index];
                  return ListTile(
                    title: Text(user.email ?? ''),
                    onTap: () {
                      controller.selectUser(user);
                      controller.clearUserSearch();
                      controller.showUserDropdown.value = false;
                    },
                  );
                },
              ),
            ),
        ],
      );
    });
  }
}
