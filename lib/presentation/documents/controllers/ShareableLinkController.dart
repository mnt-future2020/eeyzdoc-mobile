
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/request/ShareableLinkRequest.dart';
import '../../../data/models/response/ShareableLinkResponse.dart';
import '../../../domain/usecases/documents_usecase.dart';
import '../../../widgets/pickers/start_end_date_picker.dart';

class ShareableLinkController extends GetxController {
  var isLinkExpiryEnabled = false.obs;
  var isPasswordRequired = false.obs;
  var isAllowDownload = false.obs;
  var isPasswordVisible = false.obs;

  var isDateError = false.obs;
  var isPasswordError = false.obs;
  var isSettingClick = false.obs;

  var shareableLinkCode = "".obs;
  var shareableLinkId = "".obs;


  TextEditingController dateController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String documentId = "";

  final documentsController = Get.find<DocumentsController>();

  void setDate(DateTime date) {
    isDateError.value = false;
    dateController.text = "${date.day}-${date.month}-${date.year}";
  }

  void setInitialValues(ShareableLinkResponse linkResp) {
    shareableLinkId.value = linkResp.id!;
    shareableLinkCode.value = linkResp.linkCode!;

    if (linkResp.linkExpiryTime != null) {
      isLinkExpiryEnabled.value = true;

      final expiry = DateTime.parse(linkResp.linkExpiryTime!);

      final formatted = DateFormat("dd-MM-yyyy hh:mm a").format(expiry.toLocal());
      dateController.text = formatted;
    }

    if (linkResp.password != null && linkResp.password!.isNotEmpty) {
      isPasswordRequired.value = true;
      passwordController.text = linkResp.password!;
    }

    print("Value Allow LinkResp: ${linkResp.isAllowDownload}");

    isAllowDownload.value = (linkResp.isAllowDownload ?? 0) == 1;
  }
  Future<void> pickExpiryDateTime() async {
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(data: redDialogTheme, child: child!);
      },
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(data: redDialogTheme, child: child!);
      },
    );

    if (pickedTime == null) return;

    DateTime finalDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    dateController.text =
        DateFormat('dd-MM-yyyy hh:mm a').format(finalDateTime.toLocal());
  }
  Future<bool> createLinkApi(String message) async {
    if (isLinkExpiryEnabled.value && dateController.text.isEmpty) {
      isDateError.value = true;
      return false;
    }

    if (isPasswordRequired.value && passwordController.text.isEmpty) {
      isPasswordError.value = true;
      return false;
    }

    // Parse Date if enabled or send null
    String? expiryDate;
    if (isLinkExpiryEnabled.value) {
      try {
        final date = DateFormat("dd-MM-yyyy hh:mm a").parse(dateController.text).toLocal();
        expiryDate = date.toIso8601String();
      } catch (e) {
        isDateError.value = true;
        return false;
      }
    }
    final request = ShareableLinkRequest(
      id: shareableLinkId.value,
      documentId: documentId,
      isAllowDownload: isAllowDownload.value,
      password: isPasswordRequired.value
          ? passwordController.text.trim()
          : null,
      linkExpiryTime: expiryDate,
      linkCode: shareableLinkCode.value,
      message: message,
    );
    final response = await documentsController.createShareLinkApi(request);

    return response;
  }
  void onClear() {
    // Reset behavior states
    isLinkExpiryEnabled.value = false;
    isPasswordRequired.value = false;
    isAllowDownload.value = false;

    // Reset fields
    isDateError.value = false;
    isPasswordError.value = false;
    isSettingClick.value = false;

    documentId = "";

    dateController.clear();
    passwordController.clear();
  }


}
