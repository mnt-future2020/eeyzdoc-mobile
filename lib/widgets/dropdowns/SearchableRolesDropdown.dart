import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/response/dropdown_response.dart';
import '../../presentation/documents/controllers/documents_controller.dart';


class SearchableRolesDropdown extends StatelessWidget {
  const SearchableRolesDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();

    return Obx(() {
      final query = controller.searchController.text.toLowerCase();
      final filtered = controller.rolesList.where((role) {
        return role.name.toLowerCase().contains(query) &&
            !controller.isRoleSelected(role.id);
      }).toList();

      final showList = controller.showDropdown.value && filtered.isNotEmpty;
      final rolesToShow = (query.isEmpty && !controller.showAll.value)
          ? filtered.take(5).toList()
          : filtered;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchField(controller, query),
          if (showList) _buildDropdownList(controller, filtered, rolesToShow),
          if (controller.showDropdown.value && filtered.isEmpty)
            _buildEmptyDropdown(),
        ],
      );
    });
  }

  Widget _buildSearchField(DocumentsController controller, String query) {
    return Focus(
      onFocusChange: (focus) {
        controller.hasFocus.value = focus;
        controller.showDropdown.value = focus;
        if (focus) controller.showAll.value = false;
      },
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Search roles...',
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
          suffixIcon: query.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: controller.clearSearch,
          )
              : null,
        ),
        onChanged: (_) {
          controller.showDropdown.value = true;
          if (query.isNotEmpty) controller.showAll.value = true;
        },
        onTap: () => controller.showDropdown.value = true,
      ),
    );
  }

  Widget _buildDropdownList(
      DocumentsController controller,
      List<RoleDropdownResponse> filtered,
      List<RoleDropdownResponse> rolesToShow) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      constraints:
      BoxConstraints(maxHeight: rolesToShow.length > 5 ? 220 : 150),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: rolesToShow.length,
              itemBuilder: (context, index) {
                final role = rolesToShow[index];
                return ListTile(
                  title: Text(role.name),
                  onTap: () {
                    controller.selectRole(role);
                    controller.clearSearch();
                    controller.showDropdown.value = false;
                    controller.hasFocus.value = false;
                  },
                );
              },
            ),
          ),
          if (filtered.length > 5 && !controller.showAll.value)
            TextButton(
              onPressed: () => controller.showAll.value = true,
              child: Text(
                "Show All (${filtered.length - 5} more)",
                style: const TextStyle(color: Colors.red),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildEmptyDropdown() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'No roles available or already selected',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
