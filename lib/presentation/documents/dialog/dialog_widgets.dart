import 'package:docuflow/core/utils/toast_message.dart';
import 'package:docuflow/data/models/response/ShareableLinkResponse.dart';
import 'package:docuflow/presentation/reminder/controllers/reminder_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/utils/scaffold_message.dart';
import '../../../data/models/response/StartWorkflowResponse.dart';
import '../../../widgets/pickers/start_end_date_picker.dart';
import '../controllers/ShareableLinkController.dart';
import '../controllers/documents_controller.dart';
import 'package:get/get.dart';

void showDocumentDeleteDialog({
  required String documentId,
  required String title,
  required String body,
  required String type,
  required DocumentsController controller,
  void Function()? onYes,
  void Function()? onNo,
}) {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      content: Text(
        body,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onNo?.call();
            Get.back();
          },
          child: const Text("No", style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            onYes?.call();
            Get.back();
          },
          child: const Text("Yes", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

void shareLinkPreviewCheck(
  BuildContext context,
  String documentId,
  DocumentsController controller,
) async {
  if (controller.isShareLinkLoading.value) return;

  controller.isShareLinkLoading.value = true;

  final linkResp = await controller.getShareableLink(documentId);

  controller.isShareLinkLoading.value = false;

  if (linkResp == null) {
    showShareableLinkDialog(controller, documentId, () {
      print("Shareable link created successfully!");
    });
  } else {
    showShareableLinkPreviewDialog(documentId, linkResp, controller);
  }
}

void showShareableLinkPreviewDialog(
  String documentId,
  ShareableLinkResponse linkResp,
  DocumentsController docController,
) {
  final controller = Get.put(ShareableLinkController());
  controller.documentId = documentId;
  controller.setInitialValues(linkResp);

  final link = "https://eezydoc.v7testsite.in/preview/${linkResp.linkCode}";
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.85,
            maxWidth: 400,
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                const Text(
                  "Shareable Link",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                /// Header Row
                Row(
                  children: [
                    const Text(
                      "Link sharing is on",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),

                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDeleteShareLinkConfirmation(
                          linkResp.id ?? '',
                          controller,
                          Get.context!,
                        );
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () => controller.isSettingClick.toggle(),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Link + Copy
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        initialValue: link,
                        contextMenuBuilder: (context, editableTextState) {
                          return const SizedBox(); // disables copy/select menu
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    docController.isLinkExpired(linkResp.linkExpiryTime)?
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        ToastMessage.show("This shareable link has expired.");
                      },
                      child: const Text(
                        "Link Expired",
                        style: TextStyle(color: Colors.white),
                      ),
                    ):ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: link));

                        ScaffoldMessenger.of(Get.context!).showSnackBar(
                          const SnackBar(content: Text("Link Copied")),
                        );
                      },
                      child: const Text(
                        "Copy",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// SETTINGS
                Obx(
                  () => controller.isSettingClick.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Expiry
                            Text(
                              "Link expiration:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            CheckboxListTile(
                              value: controller.isLinkExpiryEnabled.value,
                              onChanged: (v) =>
                                  controller.isLinkExpiryEnabled.value = v!,
                              title: const Text("Is Link Valid until"),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),

                            /// Date picker
                            Obx(
                                  () => controller.isLinkExpiryEnabled.value
                                  ? TextFormField(
                                readOnly: true,
                                controller: controller.dateController,
                                decoration: const InputDecoration(
                                  hintText: "Choose Date & Time",
                                  border: OutlineInputBorder(),
                                ),
                                onTap: () => controller.pickExpiryDateTime(),
                              )
                                  : const SizedBox(),
                            ),

                            const Divider(),
                            Text(
                              "Password Production:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            /// Password checkbox
                            CheckboxListTile(
                              value: controller.isPasswordRequired.value,
                              onChanged: (v) =>
                                  controller.isPasswordRequired.value = v!,
                              title: const Text("Password Required"),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),

                            /// Password field
                            Obx(
                              () => controller.isPasswordRequired.value
                                  ? TextField(
                                      controller: controller.passwordController,
                                      obscureText:
                                          !controller.isPasswordVisible.value,
                                      decoration: InputDecoration(
                                        hintText: "Enter password",
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            controller.isPasswordVisible.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () => controller
                                              .isPasswordVisible
                                              .toggle(),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ),

                            const Divider(),

                            /// Allow download
                            CheckboxListTile(
                              value: controller.isAllowDownload.value,
                              onChanged: (v) =>
                                  controller.isAllowDownload.value = v!,
                              title: const Text(
                                "Users with link can download this item",
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),

                            const SizedBox(height: 10),

                            /// Update
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () async {
                                  bool success = await controller.createLinkApi(
                                    "Update Link",
                                  );

                                  if (success) {
                                    controller.onClear();
                                    Get.back();
                                  }
                                },
                                child: const Text(
                                  "Update Link",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ),

                const SizedBox(height: 10),

                /// Close
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      controller.isSettingClick.value = false;
                      controller.onClear();
                      Get.back();
                    },
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void showShareableLinkDialog(
  DocumentsController documentsController,
  String documentId,
  Function onSuccess,
) {
  final ShareableLinkController controller = Get.put(ShareableLinkController());

  controller.documentId = documentId;

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500, maxHeight: Get.height * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// TITLE
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Shareable Link",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const Divider(height: 1),

            /// SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                child: Column(
                  children: [
                    /// Link Expiry Checkbox
                    Obx(
                      () => CheckboxListTile(
                        value: controller.isLinkExpiryEnabled.value,
                        onChanged: (v) =>
                            controller.isLinkExpiryEnabled.value = v!,
                        title: const Text("Is Link Valid Until:"),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),

                    /// Date + Time Picker
                    Obx(
                      () => controller.isLinkExpiryEnabled.value
                          ? TextFormField(
                              readOnly: true,
                              controller: controller.dateController,
                              onTap: () async {
                                FocusScope.of(Get.context!).unfocus();

                                final pickedDate = await showDatePicker(
                                  context: Get.context!,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return Theme(
                                      data: redDialogTheme,
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate == null) return;

                                final pickedTime = await showTimePicker(
                                  context: Get.context!,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: redDialogTheme,
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedTime == null) return;

                                final selectedDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );

                                controller.setDate(selectedDateTime);

                                controller.dateController.text =
                                    "${pickedDate.day.toString().padLeft(2, '0')}-"
                                    "${pickedDate.month.toString().padLeft(2, '0')}-"
                                    "${pickedDate.year} "
                                    "${pickedTime.format(Get.context!)}";
                              },
                              decoration: const InputDecoration(
                                hintText: "Choose Date & Time",
                                border: OutlineInputBorder(),
                              ),
                            )
                          : const SizedBox(),
                    ),

                    const Divider(),

                    /// Password Required
                    Obx(
                      () => CheckboxListTile(
                        value: controller.isPasswordRequired.value,
                        onChanged: (v) =>
                            controller.isPasswordRequired.value = v!,
                        title: const Text("Is Password Required:"),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),

                    /// Password Field
                    Obx(
                      () => controller.isPasswordRequired.value
                          ? TextField(
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                hintText: "Enter password",
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () =>
                                      controller.isPasswordVisible.toggle(),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),

                    const Divider(),

                    /// Allow Download
                    Obx(
                      () => CheckboxListTile(
                        value: controller.isAllowDownload.value,
                        onChanged: (v) => controller.isAllowDownload.value = v!,
                        title: const Text(
                          "Users with link can download this item",
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            /// ACTION BUTTONS
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.onClear();
                      Get.delete<ShareableLinkController>();
                      Get.back();
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      final success = await controller.createLinkApi(
                        "Create Link",
                      );
                      if (success) {
                        Get.delete<ShareableLinkController>();
                        onSuccess();
                        Get.back();
                      }
                    },
                    child: const Text(
                      "Create Link",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void showStartWorkFLowDialog(
  String documentId,
  DocumentsController controller,
) {
  TextEditingController searchController = TextEditingController();
  StartWorkflowResponse? selectedWorkflow;

  Get.defaultDialog(
    title: "Start Workflow",
    titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    radius: 16,
    content: Column(
      children: [
        TextField(
          controller: searchController,
          onChanged: controller.searchWorkflow,
          decoration: InputDecoration(
            hintText: "Search workflow...",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {
                searchController.clear();
                controller.searchWorkflow(""); // refresh full list
              },
              icon: const Icon(Icons.clear),
            ),
          ),
        ),
        const SizedBox(height: 10),

        /// Workflow List
        SizedBox(
          height: 200,
          width: 300,
          child: Obx(
            () => ListView.builder(
              itemCount:
                  controller.filteredStartWorkflowNameResponseList.length,
              itemBuilder: (_, index) {
                final wf =
                    controller.filteredStartWorkflowNameResponseList[index];

                return ListTile(
                  title: Text(wf.name ?? "No Name"),
                  onTap: () {
                    selectedWorkflow = wf;
                    searchController.text = wf.name ?? "";
                  },
                );
              },
            ),
          ),
        ),
      ],
    ),

    textCancel: "No",
    cancelTextColor: Colors.black,

    textConfirm: "Yes",
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,

    onConfirm: () async {
      if (selectedWorkflow == null) {
        ScaffoldMessageShow.show("Select Name");
        return;
      }

      await controller.startWorkFlowCreate(
        documentId,
        selectedWorkflow!.id ?? '',
      );

      print("Data : ${selectedWorkflow!.name}");
      Get.back();
    },
  );

  /// Load list when dialog appears
  controller.getStartWorkFLowList();
}

void showDeleteShareLinkConfirmation(
  String linkId,
  ShareableLinkController controller,
  BuildContext context,
) {
  Get.defaultDialog(
    title: "Delete Link?",
    middleText: "Are you sure you want to delete this shareable link?",
    textCancel: "No",
    textConfirm: "Yes",
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
    onConfirm: () {
      Get.back();
      controller.documentsController.deleteSharableLink(
        linkId,
        controller,
        context,
      );
    },
  );
}

void deleteReminderConfirmation(
  String reminderId,
  ReminderController controller,
) {
  Get.defaultDialog(
    title: "Delete Reminder?",
    middleText: "Are you sure you want to delete this reminder?",
    textCancel: "No",
    textConfirm: "Yes",
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
    onConfirm: () {
      Get.back();
      controller.deleteReminder(reminderId);
    },
  );
}

void deleteUserPermissions(
  String documentId,
  String shareType,
  DocumentsController controller,
) {
  Get.defaultDialog(
    title: "Delete Permission?",
    middleText: "Are you sure you want to delete this Permission?",
    textCancel: "No",
    textConfirm: "Yes",
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
    onConfirm: () {
      Get.back();
      controller.deleteShareRole(documentId, shareType);
    },
  );
}

void showWorkFLowCommentDialog({
  required String title,
  required void Function(String comment) onYes,
  void Function()? onNo,
}) {
  final TextEditingController commentController = TextEditingController();

  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      content: TextField(
        controller: commentController,
        maxLines: 5,
        decoration: const InputDecoration(
          hintText: "Enter your comment",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (onNo != null) onNo();
            Get.back(); // Close dialog
          },
          child: const Text("No", style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            if (commentController.text.isEmpty) {
              Fluttertoast.showToast(
                msg: "Enter Comments",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.grey[850],
                textColor: Colors.white,
                fontSize: 14.0,
                timeInSecForIosWeb: 2,
              );
              return;
            }
            onYes(commentController.text.trim());
            Get.back(); // Close dialog
          },
          child: const Text("Yes", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

void restoreConfirmationDialog({
  required String title,
  void Function()? onYes,
  void Function()? onNo,
}) {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (onNo != null) onNo();
            Get.back(); // Close dialog
          },
          child: const Text("No", style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            if (onYes != null) onYes();
            Get.back(); // Close dialog
          },
          child: const Text("Yes", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
