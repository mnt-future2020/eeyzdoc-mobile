import 'dart:developer';

import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/utils/scaffold_message.dart';
import '../../data/models/request/document_role_permision_request.dart';
import '../../data/models/response/share_document_role_response.dart';
import '../../widgets/dropdowns/SearchableRolesDropdown.dart';
import '../../widgets/dropdowns/SearchableUsersDropdown.dart';
import '../../widgets/pickers/start_end_date_picker.dart';

class ShareRoleListScreen extends StatelessWidget {
  const ShareRoleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DocumentsController controller = Get.put(Get.find<DocumentsController>());

    return FocusDetector(
      onVisibilityGained: () {
        controller.getRoles();
        controller.getUsers();
        controller.getShareDocumentRoleList();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Shares',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),

        body: Obx(
              () =>
          controller.isLoading.value
              ? const Center(
            child: CircularProgressIndicator(color: Colors.red),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(
                          "Document Name",
                          controller.selectedDocument.value!.name,
                        ),
                        const SizedBox(height: 6),
                        _infoRow(
                          "Description",
                          controller
                              .selectedDocument
                              .value!
                              .description ??
                              '',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          controller.selectedRoles.value.clear();
                          openAssignRoleDialog(context, controller);
                        },
                        child: const Text(
                          "Assign/Share with Roles",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          controller.selectedUsers.value.clear();
                          openAssignUserDialog(context, controller);
                        },
                        child: const Text(
                          "Assign/Share with Users",
                          style: TextStyle(color: Colors.red),
                        ),
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

                controller.shareDocumentRoleList.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                  controller.shareDocumentRoleList.length,
                  itemBuilder: (_, index) {
                    final item =
                    controller.shareDocumentRoleList[index];
                    return permissionCard(item, () {
                      print("Edit / Action pressed");
                    }, controller);
                  },
                )
                    : const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text("No Data Shares List"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Document Info Row
  Widget _infoRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "$title:",
            style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
          ),
        ),
        Expanded(flex: 4, child: Text(value.isNotEmpty ? value : "--")),
      ],
    );
  }

  Widget permissionCard(ShareDocumentRoleResponse? item,
      VoidCallback onDelete,
      DocumentsController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Type Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getColorForType(item!, controller),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.type == "Role"
                        ? item.role?.name ?? ''
                        : "${item.user?.firstName ?? ''} ${item.user
                        ?.lastName ?? ''}"
                        .trim(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, color: Colors.white
                    ),
                  ),
                ),
                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.deleteShareRole(item.id, item.type);
                  },
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Email Display for User type only
            if (item.type == "User" && item.email != null)
              Text(
                item.user?.email ?? '',
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),

            const SizedBox(height: 10),

            // Allow Download + Date Row
            Row(
              children: [
                Icon(
                  item.isAllowDownload ? Icons.download_done : Icons.block,
                  color: item.isAllowDownload ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 6),
                Text(
                  item.isAllowDownload ? "Allow Download" : "Download Blocked",
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Time Bound Dates
            if (item.isTimeBound)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Start Date", style: TextStyle(fontSize: 12)),
                      Text(
                        formatDate(item.startDate),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("End Date", style: TextStyle(fontSize: 12)),
                      Text(
                        formatDate(item.endDate),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return "--";
    return "${date.day}/${date.month}/${date.year}";
  }

  void openAssignRoleDialog(BuildContext context,
      DocumentsController controller,) {
    final specifyPeriod = false.obs;
    final allowDownload = false.obs;
    var fromDate = DateTime.now().obs;
    var toDate = DateTime.now().add(Duration(hours: 1)).obs;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Assign/Share with Role"),
          content: Obx(
                () =>
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.85,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.55,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SearchableRolesDropdown(),

                        const SizedBox(height: 8),
                        Obx(() {
                          final selected = controller.selectedRoles;
                          if (selected.isEmpty) return const SizedBox.shrink();

                          return Wrap(
                            spacing: 8,
                            children: selected.map((role) {
                              return Chip(
                                label: Text(role.name),
                                onDeleted: () => controller.removeRole(role.id),
                              );
                            }).toList(),
                          );
                        }),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Checkbox(
                              value: specifyPeriod.value,
                              onChanged: (v) =>
                              specifyPeriod.value = v ?? false,
                            ),
                            const Text("Specify Period"),
                          ],
                        ),

                        if (specifyPeriod.value) ...[
                          const SizedBox(height: 8),
                          startEndDatePicker("From Date", fromDate),
                          const SizedBox(height: 10),
                          startEndDatePicker("To Date", toDate),
                        ],

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Checkbox(
                              value: allowDownload.value,
                              onChanged: (v) =>
                              allowDownload.value = v ?? false,
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
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                if (controller.selectedRoles.isEmpty) {
                  ScaffoldMessageShow.show("Please select at least one role");
                  return;
                }

                var documentRolePermissionRequest = DocumentSharePermissionRequest(
                  documentRolePermissions: controller.selectedRoles.map((role) {
                    return DocumentRolePermissions(
                      documentId: controller.selectedDocumentId.value,
                      roleId: role.id,
                      isTimeBound: specifyPeriod.value,
                      startDate: specifyPeriod.value
                          ? fromDate.value?.toIso8601String()
                          : null,
                      endDate: specifyPeriod.value
                          ? toDate.value?.toIso8601String()
                          : null,
                      isAllowDownload: allowDownload.value,
                      selectedRoles: [
                        SelectedRole(id: role.id, name: role.name),
                      ],
                    );
                  }).toList(),
                );

                log("Data => ${documentRolePermissionRequest.toJson()}");
                controller.saveRoleShare(
                    request: documentRolePermissionRequest);
                controller.selectedRoles.clear();
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }


  void openAssignUserDialog(BuildContext context,
      DocumentsController controller,) {
    final specifyPeriod = false.obs;
    final allowDownload = false.obs;
    var fromDate = DateTime.now().obs;
    var toDate = DateTime.now().add(Duration(hours: 1)).obs;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          title: const Text("Assign/Share with Users"),
          content: Obx(
                () =>
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * .85,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .55,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SearchableUsersDropdown(),
                        const SizedBox(height: 8),

                        Obx(() {
                          final selected = controller.selectedUsers;
                          if (selected.isEmpty) return const SizedBox.shrink();

                          return Wrap(
                            spacing: 8,
                            children: selected.map((user) {
                              return Chip(
                                label: Text(user.email ?? ''),
                                onDeleted: () => controller.removeUser(user.id??''),

                              );
                            }).toList(),
                          );
                        }),

                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: specifyPeriod.value,
                              onChanged: (v) =>
                              specifyPeriod.value = v ?? false,
                            ),
                            const Text("Specify Period"),
                          ],
                        ),

                        if (specifyPeriod.value) ...[
                          startEndDatePicker("From Date", fromDate),
                          const SizedBox(height: 10),
                          startEndDatePicker("To Date", toDate),

                        ],

                        Row(
                          children: [
                            Checkbox(
                              value: allowDownload.value,
                              onChanged: (v) =>
                              allowDownload.value = v ?? false,
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
              onPressed: () => Navigator.of(dialogContext).pop(),
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
                      documentId: controller.selectedDocumentId.value,
                      userId: user.id,
                      isTimeBound: specifyPeriod.value,
                      startDate: specifyPeriod.value
                          ? fromDate.value.toIso8601String()
                          : null,
                      endDate: specifyPeriod.value
                          ? toDate.value.toIso8601String()
                          : null,
                      isAllowDownload: allowDownload.value,
                      selectedUsers: [
                        SelectedUser(id: user.id,
                            firstName: user.firstName,
                            lastName: user.lastName,
                            userName: user.userName,
                            email: user.email),
                      ],
                    );
                  }).toList(),
                );

                log("Data : ${request.toJson()}");
                controller.saveRoleShare(request: request);
                controller.selectedUsers.clear();
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Color getColorForType(ShareDocumentRoleResponse item,
      DocumentsController controller) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.deepOrange,
      Colors.brown,
    ];

    if (item.type == "Role") {
      final roleId = item.role?.id ?? "";
      final index = controller.shareDocumentRoleList
          .indexWhere((e) => e!.role?.id == roleId);

      return colors[index % colors.length];
    }

    if (item.type == "User") {
      final userId = item.user?.id ?? "";
      final index = controller.usersList
          .indexWhere((e) => e.id == userId);
      return colors[index % colors.length];
    }

    return Colors.grey; // fallback
  }

}
