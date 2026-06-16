import 'dart:developer';

import 'package:docuflow/core/utils/scaffold_message.dart';
import 'package:docuflow/data/models/request/document_role_permision_request.dart';
import 'package:docuflow/data/models/response/share_document_role_response.dart';
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:docuflow/widgets/dropdowns/SearchableRolesDropdown.dart';
import 'package:docuflow/widgets/dropdowns/SearchableUsersDropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../widgets/pickers/start_end_date_picker.dart';
import '../../../dialog/dialog_widgets.dart';

class PermissionDetailsScreen extends StatefulWidget {
  final String documentId;

  const PermissionDetailsScreen({super.key, required this.documentId});

  @override
  State<PermissionDetailsScreen> createState() =>
      _PermissionDetailsScreenState();
}

class _PermissionDetailsScreenState extends State<PermissionDetailsScreen> {
  late final DocumentsController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<DocumentsController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedDocumentId.value = widget.documentId;

      controller.getRoles();
      controller.getUsers();
      controller.getShareDocumentRoleList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.shareDocumentRoleList.isEmpty) {
        return const Center(child: Text("No Permissions Found"));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _richRedButton(
                    label: "Assign/Share with Roles",
                    onTap: () {
                      controller.selectedRoles.clear();
                      openAssignRoleDialog(context);
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _richRedButton(
                    label: "Assign/Share with Users",
                    onTap: () {
                      controller.selectedUsers.clear();
                      openAssignUserDialog(context);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              "Permission List",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.shareDocumentRoleList.length,
              itemBuilder: (_, index) {
                final item = controller.shareDocumentRoleList[index];
                return _permissionCard(context,item!);
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _permissionCard(BuildContext context, ShareDocumentRoleResponse item) {
    final isUser = item.type == "User";
    final bool canDownload = item.isAllowDownload == true;
    final Color mainColor = canDownload ? Colors.green : Colors.red;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor, // 🔥 auto dark/light
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(isDark ? 0.25 : 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: mainColor.withOpacity(0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------- Header ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: mainColor.withOpacity(0.2),
                      child: Icon(
                        isUser ? Icons.person : Icons.group,
                        color: mainColor,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUser
                              ? "${item.user?.firstName ?? ''} ${item.user?.lastName ?? ''}".trim()
                              : item.role?.name ?? "Role",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (isUser)
                          Text(
                            item.user?.email ?? "",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                // Delete
                InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    if (item.id == null || item.type == null) {
                      ScaffoldMessageShow.show("Invalid permission entry");
                      return;
                    }
                    deleteUserPermissions(item.id, item.type, controller);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.15),
                    ),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ---------- Download Status ----------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    canDownload ? Icons.download_done : Icons.block,
                    color: mainColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    canDownload ? "Allow Download" : "Download Blocked",
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ---------- Date Range ----------
            if (item.isTimeBound == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dateColumn(context, "Start Date", item.startDate),
                  _dateColumn(context, "End Date", item.endDate),
                ],
              ),
          ],
        ),
      ),
    );
  }


  Widget _dateColumn(BuildContext context, String title, DateTime? date) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceVariant, // 🔥
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date != null
                ? DateFormat('dd-MM-yyyy hh:mm a').format(date.toLocal())
                : "—",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void openAssignRoleDialog(BuildContext context) {
    final specifyPeriod = false.obs;
    final allowDownload = false.obs;
    final fromDate = Rx<DateTime?>(null);
    final toDate = Rx<DateTime?>(null);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Assign Permission (Role)"),
        content: Obx(
          () => SizedBox(
            width: MediaQuery.of(context).size.width * .85,
            height: MediaQuery.of(context).size.height * .55,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SearchableRolesDropdown(),
                  const SizedBox(height: 10),

                  _selectedRolesChips(),

                  Row(
                    children: [
                      Checkbox(
                        value: specifyPeriod.value,
                        onChanged: (v) => specifyPeriod.value = v ?? false,
                      ),
                      const Text("Specify Period"),
                    ],
                  ),

                  if (specifyPeriod.value) ...[
                    _pickDateBox("Start Date", fromDate),
                    const SizedBox(height: 10),
                    _pickDateBox("End Date", toDate),
                  ],

                  Row(
                    children: [
                      Checkbox(
                        value: allowDownload.value,
                        onChanged: (v) => allowDownload.value = v ?? false,
                      ),
                      const Text("Allow Download"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (controller.selectedRoles.isEmpty) {
                ScaffoldMessageShow.show("Please select at least one role");
                return;
              }

              var request = DocumentSharePermissionRequest(
                documentRolePermissions: controller.selectedRoles.map((role) {
                  return DocumentRolePermissions(
                    documentId: widget.documentId,
                    roleId: role.id,
                    isTimeBound: specifyPeriod.value,
                    startDate: specifyPeriod.value
                        ? fromDate.value?.toIso8601String()
                        : null,
                    endDate: specifyPeriod.value
                        ? toDate.value?.toIso8601String()
                        : null,
                    isAllowDownload: allowDownload.value,
                    selectedRoles: [SelectedRole(id: role.id, name: role.name)],
                  );
                }).toList(),
              );

              log("ROLE SAVE => ${request.toJson()}");

              controller.saveRoleShare(request: request);
              controller.selectedRoles.clear();
              controller.getShareDocumentRoleList();

              Navigator.pop(dialogCtx);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _selectedRolesChips() {
    return Obx(() {
      final selected = controller.selectedRoles;
      if (selected.isEmpty) return const SizedBox();

      return Wrap(
        spacing: 8,
        children: selected.map((role) {
          return Chip(
            label: Text(role.name),
            onDeleted: () => controller.removeRole(role.id),
          );
        }).toList(),
      );
    });
  }

  void openAssignUserDialog(BuildContext context) {
    final specifyPeriod = false.obs;
    final allowDownload = false.obs;
    final fromDate = Rx<DateTime?>(null);
    final toDate = Rx<DateTime?>(null);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Assign Permission (User)"),
        content: Obx(
          () => SizedBox(
            width: MediaQuery.of(context).size.width * .85,
            height: MediaQuery.of(context).size.height * .55,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SearchableUsersDropdown(),
                  const SizedBox(height: 10),
                  _selectedUsersChips(),

                  Row(
                    children: [
                      Checkbox(
                        value: specifyPeriod.value,
                        onChanged: (v) => specifyPeriod.value = v ?? false,
                      ),
                      const Text("Specify Period"),
                    ],
                  ),

                  if (specifyPeriod.value) ...[
                    _pickDateBox("Start Date", fromDate),
                    const SizedBox(height: 10),
                    _pickDateBox("End Date", toDate),
                  ],

                  Row(
                    children: [
                      Checkbox(
                        value: allowDownload.value,
                        onChanged: (v) => allowDownload.value = v ?? false,
                      ),
                      const Text("Allow Download"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (controller.selectedUsers.isEmpty) {
                ScaffoldMessageShow.show("Please select at least one user");
                return;
              }

              var request = DocumentSharePermissionRequest(
                documentUserPermissions: controller.selectedUsers.map((user) {
                  return DocumentUserPermissions(
                    documentId: widget.documentId,
                    userId: user.id,
                    isTimeBound: specifyPeriod.value,
                    startDate: specifyPeriod.value
                        ? fromDate.value?.toIso8601String()
                        : null,
                    endDate: specifyPeriod.value
                        ? toDate.value?.toIso8601String()
                        : null,
                    isAllowDownload: allowDownload.value,
                    selectedUsers: [
                      SelectedUser(
                        id: user.id,
                        firstName: user.firstName,
                        lastName: user.lastName,
                        userName: user.userName,
                        email: user.email,
                      ),
                    ],
                  );
                }).toList(),
              );

              log("USER SAVE => ${request.toJson()}");

              controller.saveRoleShare(request: request);
              controller.selectedUsers.clear();
              controller.getShareDocumentRoleList();

              Navigator.pop(dialogContext);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _selectedUsersChips() {
    return Obx(() {
      final selected = controller.selectedUsers;
      if (selected.isEmpty) return const SizedBox();

      return Wrap(
        spacing: 8,
        children: selected.map((user) {
          return Chip(
            label: Text(user.email ?? ""),
            onDeleted: () => controller.removeUser(user.id ?? ""),
          );
        }).toList(),
      );
    });
  }

  Widget _pickDateBox(String label, Rx<DateTime?> selected) {
    return GestureDetector(
      onTap: () async {
        // Pick DATE
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selected.value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2050),
            builder: (context, child) {
              return Theme(
                data: redDialogTheme,
                child: child!,
              );
            }
        );

        if (pickedDate != null) {
          // Pick TIME
          final pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(selected.value ?? DateTime.now()),
              builder: (context, child) {
                return Theme(
                  data: redDialogTheme,
                  child: child!,
                );
              }
          );

          if (pickedTime != null) {
            final combined = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );

            selected.value = combined;
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selected.value != null
                      ? DateFormat("dd-MM-yyyy hh:mm a")
                      .format(selected.value!)
                      : "",
                ),
                const Icon(Icons.calendar_month, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _richRedButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1.4,
            color: Colors.red.shade600,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.red.withOpacity(0.02),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
            ),
          ),
        ),
      ),
    );
  }

}
