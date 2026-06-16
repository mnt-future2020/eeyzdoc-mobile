import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/response/file_request_response.dart';
import '../../../widgets/pickers/start_end_date_picker.dart';
import '../controllers/file_request_controller.dart';

class AddFileRequestPage extends StatelessWidget {
  final FileRequestResponse? data;
  final controller = Get.find<FileRequestController>();

  AddFileRequestPage({super.key, this.data}) {
    if (data != null) {
      controller.loadEditData(data!);
    } else {
      controller.initAddMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data != null ? 'Edit File Request' : 'Add File Request',
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
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller.subjectController,
                decoration: const InputDecoration(
                  labelText: "Subject",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Subject Required" : null,
              ),
              SizedBox(height: 12),

              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Email Required" : null,
              ),
              SizedBox(height: 12),

              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Allow File Extension",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      children: controller.allExtensions.entries.map((entry) {
                        final label = entry.key;
                        final id = entry.value;
                        final isSelected = controller.selectedExtensions
                            .contains(id);

                        return FilterChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              controller.selectedExtensions.add(id);
                            } else {
                              controller.selectedExtensions.remove(id);
                            }
                          },
                          selectedColor: Colors.red.shade300,
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 6),

                    if (controller.selectedExtensions.isEmpty)
                      const Text(
                        "Allow File Extension is Required",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              TextFormField(
                controller: controller.maxUploadDocumentController,
                decoration: const InputDecoration(
                  labelText: "Maximum Document Upload",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    controller.maxUploadDocument.value = int.tryParse(v) ?? 1,
              ),
              SizedBox(height: 12),

              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedFileSize.value,
                  hint: const Text("Select max file size"),
                  decoration: const InputDecoration(
                    labelText: "Maximum File Size Upload",
                    border: OutlineInputBorder(),
                  ),
                  items: controller.fileSizeOptions.keys
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => controller.selectedFileSize.value = v,
                  validator: (v) =>
                      v == null ? "Please select max file size" : null,
                ),
              ),

              SizedBox(height: 12),

              Obx(
                () => CheckboxListTile(
                  title: Text("Is password Required"),
                  value: controller.isPasswordRequired.value,
                  onChanged: (v) =>
                      controller.isPasswordRequired.value = v ?? false,
                ),
              ),

              Obx(
                () => controller.isPasswordRequired.value
                    ? TextFormField(
                        controller: controller.passwordController,
                        decoration: const InputDecoration(
                          labelText: "Enter Password",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            controller.isPasswordRequired.value &&
                                (v == null || v.isEmpty)
                            ? "Password is required"
                            : null,
                      )
                    : SizedBox.shrink(),
              ),
              SizedBox(height: 12),

              Obx(
                () => CheckboxListTile(
                  title: Text("Is Link Valid until"),
                  value: controller.isLinkValidUntil.value,
                  onChanged: (v) =>
                      controller.isLinkValidUntil.value = v ?? false,
                ),
              ),
              Obx(() {
                if (!controller.isLinkValidUntil.value) {
                  return const SizedBox.shrink();
                }
                return InkWell(
                  onTap: () async {
                    DateTime now = DateTime.now();

                    DateTime initialDate = controller.selectedDate.value ?? now;

                    if (initialDate.isBefore(now)) {
                      initialDate = now;
                    }

                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: now,
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(data: redDialogTheme, child: child!);
                      },
                    );
                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (context, child) {
                          return Theme(data: redDialogTheme, child: child!);
                        },
                      );

                      if (pickedTime != null) {
                        final combinedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );

                        controller.selectedDate.value = combinedDateTime;
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.selectedDate.value == null
                              ? "Select Date & Time"
                              : "${DateFormat('dd-MM-yyyy').format(controller.selectedDate.value!)} "
                                    "${DateFormat('hh:mm a').format(controller.selectedDate.value!)}",
                        ),
                        const Icon(Icons.calendar_month),
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () => data == null
                              ? controller.save(context, "")
                              : controller.save(context, data!.id),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : Text(
                            data == null
                                ? 'Save File Request'
                                : 'Edit File Request',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
