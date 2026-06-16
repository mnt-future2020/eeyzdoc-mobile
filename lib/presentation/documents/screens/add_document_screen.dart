import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/data/models/response/document_response.dart';
import 'package:docuflow/data/models/response/dropdown_response.dart';
import 'package:docuflow/data/models/response/user_dropdown_response.dart';
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:docuflow/widgets/pickers/file_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;

import '../../../widgets/IncrementDecrementField.dart';
import '../../../widgets/pickers/start_end_date_picker.dart';

class AddDocumentScreen extends StatelessWidget {
  final DocumentResponse? documentResponse;

  final DocumentsController controller = Get.find<DocumentsController>();
  final RouterController routerController = Get.find<RouterController>();

  AddDocumentScreen({super.key, this.documentResponse}) {
    if (documentResponse != null) {
      controller.loadEditData(documentResponse!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityGained: () {
        controller.getDocumentStatusList();
        controller.getCategory();
        controller.getClients();
        controller.getUsers();
        controller.getRoles();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            documentResponse == null ? 'Add Document' : "Edit Document",
            style:
                Theme.of(context).appBarTheme.titleTextStyle ??
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
          ),
          backgroundColor: Colors.red,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Document Upload Section
                documentResponse == null
                    ? Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: SingleFilePicker(
                            file: controller.selectedDocumentFile.value,
                            onChanged: (file) {
                              controller.selectedDocumentFile.value = file;
                              controller.nameController.text =  p.basename(file!.path);
                            }
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                const SizedBox(height: 16),

                _buildDocumentStatus(),

                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.nameController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                InkWell(
                  onTap: () => controller.openCategorySelector(context),
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: controller.categoryController,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      decoration: InputDecoration(
                        labelText: "Select Category",
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                _buildClientField(context),
                const SizedBox(height: 16),

                TextFormField(
                  controller: controller.descriptionController,
                  maxLines: 3,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 24),
                _buildCategorySection(),
                const SizedBox(height: 24),
                _buildMetaTags(context),
                const SizedBox(height: 24),
                documentResponse!=null?SizedBox.shrink():_buildAssignWithRolesSection(context),
                const SizedBox(height: 24),
                documentResponse!=null?SizedBox.shrink(): _buildAssignWithUsersSection(context),
                const SizedBox(height: 32),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentStatus() {
    return Obx(() {
      final items = controller.documentStatusList;
      final selectedId = controller.selectedDocumentStatusId.value;

      return DropdownButtonFormField<String>(
        value: items.any((c) => c.id == selectedId) ? selectedId : null,
        decoration: const InputDecoration(
          labelText: 'Document Status',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: items.map((status) {
          return DropdownMenuItem<String>(
            value: status.id,
            child: Text(status.name),
          );
        }).toList(),
        onChanged: (value) {
          controller.selectedDocumentStatusId.value = value!;
        },
      );
    });
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRetentionPeriod(),
        const SizedBox(height: 16),
        _buildRetentionAction(),
        const SizedBox(height: 16),
        _buildStorage(),
      ],
    );
  }

  Widget _buildRetentionPeriod() {
    return IncrementDecrementField();
  }

  Widget _buildRetentionAction() {
    return Obx(() => DropdownButtonFormField<int>(
      value: controller.selectedRetentionAction.value,
      onChanged: controller.updateRetentionAction,
      items: controller.retentionActions.entries.map((e) {
        return DropdownMenuItem<int>(
          value: e.key,
          child: Text(e.value),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Retention Action',
        border: OutlineInputBorder(),
      ),
    ));
  }

  Widget _buildStorage() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedStorage.value,
        onChanged: controller.updateStorage,
        decoration: const InputDecoration(
          labelText: 'Storage',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: controller.storageOptions
            .map(
              (storage) => DropdownMenuItem<String>(
                value: storage,
                child: Text(storage),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildClientField(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final items = controller.clientList;
      final selectedId = controller.selectedClientId.value;
      final validValue = items.any((c) => c.id == selectedId) ? selectedId : null;

      return DropdownButtonFormField<String>(
        value: validValue,
        onChanged: controller.updateClient,
        dropdownColor: isDark ? Colors.grey[850] : Colors.white, // dropdown menu bg
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87, // selected text
        ),
        decoration: InputDecoration(
          labelText: 'Client',
          labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red, // Red for focused border
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          fillColor: isDark ? Colors.grey[900] : Colors.white,
          filled: true,
        ),
        items: items.map((client) {
          return DropdownMenuItem<String>(
            value: client.id,
            child: Text(
              client.companyName ?? '',
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildMetaTags(BuildContext context) {
    final tagController = TextEditingController();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show tags as Chips
          if (controller.documentMetaTagList.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.documentMetaTagList
                  .map(
                    (tagModel) => Chip(
                      label: Text(
                        tagModel.metatag ?? '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onDeleted: () => controller.removeMetaTag(tagModel),
                      deleteIcon: const Icon(Icons.close, size: 16),
                    ),
                  )
                  .toList(),
            ),

          const SizedBox(height: 12),

          // Add new tags
          TextField(
            controller: tagController,
            decoration: InputDecoration(
              labelText: 'Add Meta Tag',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final tag = tagController.text.trim();
                  if (tag.isNotEmpty) {
                    controller.addMetaTag(tag);
                    tagController.clear();
                  }
                },
              ),
            ),
            onSubmitted: (value) {
              final tag = value.trim();
              if (tag.isNotEmpty) {
                controller.addMetaTag(tag);
                tagController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAssignWithRolesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.selectedRoles.map((role) {
              return Chip(
                label: Text(role.name),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => controller.selectedRoles.remove(role),
                backgroundColor: Colors.red.withOpacity(0.1),
                labelStyle: const TextStyle(color: Colors.red),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        _buildSearchableRolesDropdown(),
        const SizedBox(height: 16),

        Obx(
          () => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: controller.rolesSpecifyPeriod.value,
            onChanged: controller.toggleRolesSpecifyPeriod,
            title: const Text('Specify the Period'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        const SizedBox(height: 8),

        Obx(
          () => controller.rolesSpecifyPeriod.value
              ? Row(
                  children: [
                    Expanded(
                      child: _DateField(
                        label: 'Choose a Start Date',
                        value: controller.formatDateTime(
                          controller.rolesStartDate.value,
                        ),
                        onTap: () => pickDateTime(
                          context: context,
                          onSelected: controller.setRolesStartDate,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateField(
                        label: 'Choose a End Date',
                        value: controller.formatDateTime(
                          controller.rolesEndDate.value,
                        ),
                        onTap: () => pickDateTime(
                          context: context,
                          onSelected: controller.setRolesEndDate,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        Obx(
          () => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: controller.rolesAllowDownload.value,
            onChanged: controller.toggleRolesAllowDownload,
            title: const Text('Allow Download'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchableRolesDropdown() {
    return Obx(() {
      final controller = Get.find<DocumentsController>();

      final query = controller.searchController.text.toLowerCase();

      final filteredRoles = controller.rolesList.where((role) {
        final matchesQuery = role.name.toLowerCase().contains(query);
        final notSelected = !controller.isRoleSelected(role.id);
        return matchesQuery && notSelected;
      }).toList();

      List<RoleDropdownResponse> rolesToShow = [];
      if (controller.showDropdown.value && filteredRoles.isNotEmpty) {
        rolesToShow = (query.isEmpty && !controller.showAll.value)
            ? filteredRoles.take(5).toList()
            : filteredRoles;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Focus(
            onFocusChange: (focus) {
              controller.hasFocus.value = focus;
              if (focus) {
                controller.showDropdown.value = true;
                controller.showAll.value = false;
              } else {
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (!controller.hasFocus.value) {
                    controller.showDropdown.value = false;
                  }
                });
              }
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
          ),

          if (controller.showDropdown.value && filteredRoles.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              constraints: BoxConstraints(
                maxHeight: rolesToShow.length > 5 ? 220 : 150,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: rolesToShow.length,
                      itemBuilder: (context, index) {
                        final role = rolesToShow[index];
                        return ListTile(
                          title: Text(role.name, style: TextStyle(
                            color: Colors.black,
                          ),),
                          onTap: () {
                            controller.selectRole(role);
                            controller.clearSearch();
                            controller.showDropdown.value = false;
                            controller.hasFocus.value = false;
                          },
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                        );
                      },
                    ),
                  ),

                  if (query.isEmpty &&
                      filteredRoles.length > 5 &&
                      !controller.showAll.value)
                    TextButton(
                      onPressed: () => controller.showAll.value = true,
                      child: Text(
                        'Show All (${filteredRoles.length - 5} more)',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),

          if (controller.showDropdown.value && filteredRoles.isEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'No roles available or already selected',
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildSearchableUsersDropdown() {
    return Obx(() {
      final controller = Get.find<DocumentsController>();

      final query = controller.userSearchController.text.toLowerCase();

      final filteredUsers = controller.usersList.where((role) {
        final matchesQuery = role.userName!.toLowerCase().contains(query);
        final notSelected = !controller.isRoleSelected(role.id!);
        return matchesQuery && notSelected;
      }).toList();

      List<UserDropdownResponse> rolesToShow = [];
      if (controller.showUserDropdown.value && filteredUsers.isNotEmpty) {
        rolesToShow = (query.isEmpty && !controller.showAll.value)
            ? filteredUsers.take(5).toList()
            : filteredUsers;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Focus(
            onFocusChange: (focus) {
              controller.hasFocus.value = focus;
              if (focus) {
                controller.showUserDropdown.value = true;
                controller.showAll.value = false;
              } else {
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (!controller.hasFocus.value) {
                    controller.showUserDropdown.value = false;
                  }
                });
              }
            },
            child: TextField(
              controller: controller.userSearchController,
              decoration: InputDecoration(
                hintText: 'Search Users...',
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
                controller.showUserDropdown.value = true;
                if (query.isNotEmpty) controller.showAll.value = true;
              },
              onTap: () => controller.showUserDropdown.value = true,
            ),
          ),

          if (controller.showUserDropdown.value && filteredUsers.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              constraints: BoxConstraints(
                maxHeight: rolesToShow.length > 5 ? 220 : 150,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: rolesToShow.length,
                      itemBuilder: (context, index) {
                        final role = rolesToShow[index];
                        return ListTile(
                          title: Text(role.userName ?? '',style: TextStyle(color: Colors.black),),
                          onTap: () {
                            controller.selectUser(role);
                            controller.clearSearch();
                            controller.showUserDropdown.value = false;
                            controller.hasFocus.value = false;
                          },
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                        );
                      },
                    ),
                  ),

                  if (query.isEmpty &&
                      filteredUsers.length > 5 &&
                      !controller.showAll.value)
                    TextButton(
                      onPressed: () => controller.showAll.value = true,
                      child: Text(
                        'Show All (${filteredUsers.length - 5} more)',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),

          if (controller.showUserDropdown.value && filteredUsers.isEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'No Users available or already selected',
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildAssignWithUsersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.selectedUsers.map((user) {
              return Chip(
                label: Text(user.userName ?? ''),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => controller.selectedUsers.remove(user),
                backgroundColor: Colors.red.withOpacity(0.1),
                labelStyle: const TextStyle(color: Colors.red),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        _buildSearchableUsersDropdown(),
        const SizedBox(height: 16),

        Obx(
          () => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: controller.usersSpecifyPeriod.value,
            onChanged: controller.toggleUsersSpecifyPeriod,
            title: const Text('Specify the Period'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        const SizedBox(height: 8),

        Obx(
          () => controller.usersSpecifyPeriod.value
              ? Row(
                  children: [
                    Expanded(
                      child: _DateField(
                        label: 'Choose a Start Date',
                        value: controller.formatDateTime(
                          controller.usersStartDate.value,
                        ),
                        onTap: () => pickDateTime(
                          context: context,
                          onSelected: controller.setUsersStartDate,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateField(
                        label: 'Choose a End Date',
                        value: controller.formatDateTime(
                          controller.usersEndDate.value,
                        ),
                        onTap: () => pickDateTime(
                          context: context,
                          onSelected: controller.setUsersEndDate,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        Obx(
          () => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: controller.usersAllowDownload.value,
            onChanged: controller.toggleUsersAllowDownload,
            title: const Text('Allow Download'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(
            () => ElevatedButton(
              onPressed: () => documentResponse == null
                  ? controller.saveDocument(context)
                  : controller.editDocument(context, documentResponse!.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(documentResponse == null ? 'Save' : "Update"),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddTagDialog() {
    final tagController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Add Meta Tag'),
        content: TextField(
          controller: tagController,
          decoration: const InputDecoration(
            hintText: 'Enter tag name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final tag = tagController.text.trim();
              if (tag.isNotEmpty) {
                controller.addMetaTag(tag);
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> pickDateTime({
    required BuildContext context,
    required void Function(DateTime) onSelected,
  }) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
        builder: (context, child) {
          return Theme(
            data: redDialogTheme,
            child: child!,
          );
        }
    );

    if (pickedDate == null) return;

    // Step 2: Pick Time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: redDialogTheme,
            child: child!,
          );
        }
    );

    if (pickedTime == null) return;

    // Step 3: Combine Date + Time
    final selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    onSelected(selectedDateTime);
  }
}


class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        child: Text(
          value.isEmpty ? ' ' : value,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
