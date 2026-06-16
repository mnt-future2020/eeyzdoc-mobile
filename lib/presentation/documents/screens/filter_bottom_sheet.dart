import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/pickers/start_end_date_picker.dart';
import '../controllers/DocumentFilterController.dart';

class FilterBottomSheet extends StatelessWidget {
  final bool documentAssign;

  FilterBottomSheet({super.key, required this.documentAssign});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentFilterController>();
    controller.setDocumentAssign(documentAssign);
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Filter Documents",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: "Search by Name or Description",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                controller.searchNameCtrl.text = val;
                controller.fetchDocuments();
              },
            ),
            const SizedBox(height: 10),

            TextField(
              decoration: const InputDecoration(
                labelText: "Search by Meta Tag",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                controller.metaTagsCtrl.text = val;
                controller.fetchDocuments();
              },
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: () => controller.openCategorySelector(context),
              child: IgnorePointer(
                child: TextFormField(
                  controller: controller.categoryController,
                  decoration: const InputDecoration(
                    labelText: "Select Category",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Location / Storage
            Obx(() {
              return DropdownButtonFormField<String>(
                decoration: InputDecoration(border: OutlineInputBorder()),
                value: controller.selectedLocation.value,
                hint: const Text("Select Storage/Location"),
                items: ['Local Disk (Default)', 'S3 storage']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  controller.selectedLocation.value = val;
                  controller.fetchDocuments();
                },
              );
            }),
            const SizedBox(height: 10),

            // Created Date Range
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.startDate.value ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2050),
                );
                if (picked != null) {
                  controller.startDate.value = picked;
                  controller.fetchDocuments();
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(
                  () => Text(
                    controller.startDate.value != null
                        ? "${controller.startDate.value!.day}-${controller.startDate.value!.month}-${controller.startDate.value!.year}"
                        : "Created Date",
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            _buildClientField(controller),
            const SizedBox(height: 16),
            _buildDocumentStatus(controller),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back(); // closes bottom sheet
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    controller.resetFilters();
                  },
                  child: const Text(
                    "Reset Filters",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildClientField(DocumentFilterController controller) {
    return Obx(() {
      final items = controller.clientList;
      final selectedId = controller.selectedClientId.value;

      return DropdownButtonFormField<String>(
        value: items.any((c) => c.id == selectedId) ? selectedId : null,
        decoration: const InputDecoration(
          labelText: 'Select Client',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: items.map((status) {
          return DropdownMenuItem<String>(
            value: status.id,
            child: Text(status.companyName),
          );
        }).toList(),
        onChanged: (value) {
          controller.selectedClientId.value = value!;
          print("Client Id : ${controller.selectedClientId.value} : $value");
          controller.fetchDocuments();
        },
      );
    });
  }

  Widget _buildDocumentStatus(DocumentFilterController controller) {
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
          controller.fetchDocuments();
        },
      );
    });
  }
}
