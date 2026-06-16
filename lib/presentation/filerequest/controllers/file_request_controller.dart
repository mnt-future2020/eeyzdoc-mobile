import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/data/models/request/DocumentWorkflowRequest.dart';
import 'package:docuflow/data/models/request/file_request_add.dart';
import 'package:docuflow/data/models/request/file_request_query.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/FileRequestDocumentResponse.dart';
import 'package:docuflow/data/models/response/reminder_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';
import 'package:docuflow/domain/usecases/file_request_usecase.dart';
import 'package:docuflow/domain/usecases/work_flow_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/routes/router_controller.dart';
import '../../../core/utils/scaffold_message.dart';
import '../../../data/models/response/file_request_response.dart';
import '../../../data/models/response/work_flow_response.dart';
import '../../../domain/usecases/reminder_usecase.dart';
import 'package:go_router/go_router.dart'; // ADD THIS

class FileRequestController extends GetxController {
  RxList<FileRequestResponse?> fileList = <FileRequestResponse>[].obs;
  RxList<FileRequestDocument?> fileDetailsList = <FileRequestDocument>[].obs;
  RxList<FileRequestResponse?> filteredList = <FileRequestResponse>[].obs;
  var isLoading = false.obs;
  var pageSize = 10.obs;
  var currentPage = 0.obs;
  final FileRequestUseCase fileRequestUseCase;
  var formKey = GlobalKey<FormState>();

  var searchCtrl = TextEditingController();
  var subjectController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final routerController = Get.find<RouterController>();

  var isPasswordRequired = false.obs;
  var isLinkValidUntil = false.obs;

  final RxList<int> selectedExtensions = <int>[].obs;
  RxnString selectedFileSize = RxnString();
  var maxUploadDocument = 0.obs;
  var maxUploadDocumentController = TextEditingController();

  final fileSizeOptions = {
    "Less than 1 MB": 1,
    "Less than 2 MB": 2,
    "Less than 5 MB": 5,
    "Less than 10 MB": 10,
    "Less than 25 MB": 25,
    "Less than 50 MB": 50,
    "Less than 100 MB": 100,
    "Greater than 100 MB": 101,
  };
  final Map<String, int> allExtensions = const {
    "Office": 0,
    "Pdf": 1,
    "Image": 2,
    "Text": 3,
    "Audio": 4,
    "Video": 5,
    "Other": 6,
  };
  var selectedDate = Rxn<DateTime>();

  FileRequestController({required this.fileRequestUseCase});

  @override
  void onInit() {
    super.onInit();
  }

  void initAddMode() {
    selectedFileSize.value = "Less than 5 MB";
  }

  void initEditMode(int? apiSizeMb) {
    if (apiSizeMb == null) {
      selectedFileSize.value = null;
      return;
    }

    MapEntry<String, int>? match;

    for (final e in fileSizeOptions.entries) {
      if (e.value == apiSizeMb) {
        match = e;
        break;
      }
    }

    // exact match → select
    // no match (20 MB) → null → show hint
    selectedFileSize.value = match?.key;
  }

  Future<void> getFileRequestList() async {
    isLoading.value = true;

    try {
      FileRequestQuery fileRequestQuery = FileRequestQuery(
        fields: "",
        orderBy: "createdDate desc",
        pageSize: pageSize.value,
        skip: currentPage.value * pageSize.value,
        search: "",
        id: "",
        email: "",
        subject: "",
      );
      fileList.value =
          await fileRequestUseCase.getFileRequestApi(fileRequestQuery) ?? [];
      filteredList.assignAll(fileList);
      print("FileListResponseList ${fileList.value.length}");
    } catch (e, st) {
      print("WorkFlow error: $e, StackTrace: $st");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFileRequest(
    BuildContext context,
    FileRequestAdd fileRequestAdd,
  ) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await fileRequestUseCase.addFileRequestApi(
        fileRequestAdd,
      );

      if (response!.status == "Success") {
        ScaffoldMessageShow.show("${response.message}");
        routerController.router.pop(); // back to list screen
      } else {
        ScaffoldMessageShow.show("${response.message}");
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fileDetailsRequest(String fileId) async {
    isLoading.value = true;
    try {
      final response = await fileRequestUseCase.fileDetailsRequestApi(fileId);
      routerController.router.push(
        AppScreens.fileRequestAddScreen,
        extra: response,
      );
      isLoading.value = false;
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void filterList(String query) {
    if (query.isEmpty) {
      filteredList.value = fileList;
    } else {
      filteredList.value = fileList
          .where(
            (file) => (file!.subject ?? "").toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  Future<void> loadFileDetails(String fileId) async {
    try {
      isLoading.value = true;
      fileDetailsList.value =
          await fileRequestUseCase.getFileDetailsApi(fileId) ?? [];
      print("FileListResponseList ${fileDetailsList.value.length}");
    } catch (e, st) {
      print("WorkFlow error: $e, StackTrace: $st");
    } finally {
      isLoading.value = false;
    }
  }

  void onPageSizeChange(int value) {
    pageSize.value = value;
    currentPage.value = 0;
    getFileRequestList();
  }

  void nextPage() {
    currentPage.value++;
    getFileRequestList();
  }

  void editFileRequest(FileRequestResponse fileRequestResponse) {
    print("Id File : ${fileRequestResponse.id}");
    fileDetailsRequest(fileRequestResponse.id!);
  }

  void viewFileDetailsRequest(String fileId) {
    routerController.router.push(AppScreens.fileDetailsScreen, extra: fileId);
  }

  Future<void> deleteFileRequest(
    BuildContext context,
    FileRequestResponse? fileRequestAdd,
  ) async {
    isLoading.value = true;
    try {
      final response = await fileRequestUseCase.deleteFileRequestApi(
        fileRequestAdd!,
      );

      if (response!.status == "Success") {
        ScaffoldMessageShow.show("${response.message}");
        fileList.removeWhere((e) => e!.id == fileRequestAdd.id);
      } else {
        ScaffoldMessageShow.show("${response.message}");
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> copyFileRequest(
    BuildContext context,
    FileRequestResponse fileRequestAdd,
  ) async {
    final link =
        "https://eezydoc.v7testsite.in/file-requests/preview/${fileRequestAdd.id}";

    Clipboard.setData(ClipboardData(text: link));
    // isLoading.value = true;
    try {
      final response = await fileRequestUseCase.copyFileRequestApi(
        fileRequestAdd.id!,
      );

      if (response!.status == "Success") {
        ScaffoldMessageShow.show("${response.message}");
      } else {
        ScaffoldMessageShow.show("${response.message}");
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      //  isLoading.value = false;
    }
  }

  void loadEditData(FileRequestResponse data) {
    subjectController.text = data.subject ?? "";
    emailController.text = data.email ?? "";

    selectedExtensions.clear();

    final extList = data.allowExtension!.split(',');

    for (var name in extList) {
      final trimmedName = name.trim();
      final id = allExtensions[trimmedName];
      if (id != null) {
        selectedExtensions.add(id);
      }
    }
    initEditMode(data.sizeInMb);

    maxUploadDocument.value = data.maxDocument!;
    maxUploadDocumentController.text = "${maxUploadDocument.value}";
    if (data.hasPassword == true) {
      isPasswordRequired.value = true;
      passwordController.text = data.password ?? '';
    } else {
      isPasswordRequired.value = false;
    }

    /// Link Expiry
    if (data.linkExpiryTime != null) {
      isLinkValidUntil.value = true;

      try {
        selectedDate.value = DateTime.parse(data.linkExpiryTime.toString());
      } catch (e) {
        selectedDate.value = null;
      }
    } else {
      isLinkValidUntil.value = false;
      selectedDate.value = null;
    }
  }

  Future<void> save(BuildContext context, String? fileId) async {
    if (!formKey.currentState!.validate()) return;

    if (isPasswordRequired.isTrue && passwordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Password is required!");
      return;
    }

    if (selectedExtensions.isEmpty) {
      Get.snackbar("Error", "Select at least one file extension");
      return;
    }
    final sizeToSend = fileSizeOptions[selectedFileSize.value]!;

    FileRequestAdd req = FileRequestAdd(
      id: fileId,
      subject: subjectController.text.toString().trim(),
      email: emailController.text.toString().trim(),
      fileExtension: selectedExtensions,
      maxDocument: maxUploadDocument.value,
      sizeInMb: sizeToSend,
      isPasswordRequired: isPasswordRequired.value,
      password: passwordController.text.trim(),
      isLinkExpired: isLinkValidUntil.value,
      expiryDate: selectedDate.value,
    );

    print("API Payload: ${req.toJson()}");
    addFileRequest(context, req);
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      getFileRequestList();
    }
  }

  bool isLinkExpired(DateTime? expiryTime) {
    if (expiryTime == null) return false;

    return DateTime.now().isAfter(expiryTime);
  }

  void resetForm() {
    formKey.currentState?.reset();
    subjectController.clear();
    emailController.clear();
    maxUploadDocumentController.clear();
    passwordController.clear();
    selectedExtensions.clear();
    selectedDate.value = null;
    selectedFileSize.value = null;
    maxUploadDocument.value = 0;
    isPasswordRequired.value = false;
    isLinkValidUntil.value = false;
  }
}
