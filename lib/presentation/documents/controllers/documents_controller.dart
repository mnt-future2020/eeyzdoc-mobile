import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/data/models/request/edit_document_request.dart';
import 'package:docuflow/data/models/request/share_document_request.dart';
import 'package:docuflow/data/models/response/CategoryDropDownResponse.dart';
import 'package:docuflow/data/models/response/clientDropdownResponse.dart';
import 'package:docuflow/data/models/response/comment_model.dart';
import 'package:docuflow/data/models/response/document_meta_tag.dart';
import 'package:docuflow/data/models/response/document_response.dart';
import 'package:docuflow/data/models/response/dropdown_response.dart';
import 'package:docuflow/data/models/response/share_document_role_response.dart';
import 'package:docuflow/data/models/response/user_dropdown_response.dart';
import 'package:docuflow/domain/usecases/documents_usecase.dart';
import 'package:docuflow/my_documents_screen.dart';
import 'package:docuflow/presentation/documents/controllers/ShareableLinkController.dart';
import 'package:docuflow/presentation/main/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

import '../../../app/routes/router_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/scaffold_message.dart';
import '../../../data/models/request/ShareableLinkRequest.dart';
import '../../../data/models/request/document_filter_request.dart';
import '../../../data/models/request/document_request.dart';
import '../../../data/models/request/document_role_permision_request.dart';
import '../../../data/models/response/ShareableLinkResponse.dart';
import '../../../data/models/response/StartWorkflowResponse.dart';
import '../../../data/models/response/document_status.dart';
import '../../../data/models/response/success_response.dart';
import '../../../data/repositories/SignatureModel.dart';
import '../../../widgets/dropdowns/CategoryTreeView.dart';
import '../../user/controllers/auth_controller.dart';

class DocumentsController extends GetxController {
  late final DocumentsUseCase documentsUseCase;

  DocumentsController({required this.documentsUseCase});
  Timer? _debounce;

  final routerController = Get.find<RouterController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var shareableLinkResponse = Rxn<ShareableLinkResponse>();
  AuthController authController = Get.put(Get.find<AuthController>());

  final TextEditingController commentsTextEditingController =
      TextEditingController();
  final TextEditingController docIdController = TextEditingController();
  RxList<SignatureModel?> signatures = <SignatureModel>[].obs;
  final retentionAction = Rx<int?>(null);

  RxList<ShareDocumentRoleResponse?> shareDocumentRoleList =
      <ShareDocumentRoleResponse>[].obs;
  final categoryController = TextEditingController();
  bool? isAssignedDocs;
  Rx<File?> selectedDocumentFile = Rx<File?>(null);
  RxList<CommentModel> commentModelList = <CommentModel>[].obs;
  RxList<StartWorkflowResponse> startWorkflowNameResponseList =
      <StartWorkflowResponse>[].obs;
  RxList<StartWorkflowResponse> filteredStartWorkflowNameResponseList =
      <StartWorkflowResponse>[].obs;

  RxString searchStartWorkFLowQuery = "".obs;

  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  RxBool isLoadMore = false.obs;
  RxBool isShareLinkLoading = false.obs;

  int pageSize = 10;
  int skip = 0;
  bool hasMoreData = true;

  Rx<Uint8List?> signatureBytes = Rx<Uint8List?>(null);
  RxString signatureBase64 = ''.obs;

  var selectedClientId = RxnString();
  var selectedDocumentStatusId = RxnString();
  final RxString selectedStorage = 'Local Disk (Default)'.obs;

  final selectedCategory = Rx<CategoryDropdownResponse?>(null);

  final RxString selectedDocumentId = ''.obs;
  final selectedDocument = Rx<DocumentResponse?>(null);

  final RxInt selectedRetentionPeriod = (-1).obs;
  final RxInt selectedRetentionAction = (0).obs;
  final rolesList = <RoleDropdownResponse>[].obs;
  final selectedRoles = <RoleDropdownResponse>[].obs;
  final clientList = <ClientDropdownResponse>[].obs;
  final documentStatusList = <DocumentStatus>[].obs;
  final categoryList = <CategoryDropdownResponse>[].obs;
  final roleTextCtrl = TextEditingController();

  final rolesSpecifyPeriod = false.obs;
  final rolesAllowDownload = false.obs;

  final rolesStartDate = Rx<DateTime?>(null);
  final rolesEndDate = Rx<DateTime?>(null);

  // Dropdown & Search State
  final searchController = TextEditingController();
  final userSearchController = TextEditingController();
  final showDropdown = false.obs;
  final showUserDropdown = false.obs;
  final hasFocus = false.obs;
  final showAll = false.obs;

  bool isRoleSelected(String id) {
    return selectedRoles.any((r) => r.id == id);
  }

  RxString searchQuery = ''.obs;
  RxString selectedFilter = 'All'.obs;
  final List<String> filters = [
    'All',
    'Recent',
    'Signed',
    'Pending',
    'Completed',
  ];

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  void showMore(BuildContext context, DocumentResponse document) {
    selectedDocumentId.value = document.id;
    selectedDocument.value = document;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) =>
          MoreActionsMenu(documentResponse: document, flagShow: false),
    );
  }

  final List<String> statusOptions = ['New File', 'Under Review'];

  final retentionActions = {0: 'Archive', 1: 'Permanent Delete', 2: 'Expire'};
  final List<String> storageOptions = ['Local Disk (Default)', 'S3 storage'];

  final RxList<DocumentMetaTag> documentMetaTagList = <DocumentMetaTag>[].obs;

  @override
  void onInit() {
    ever(selectedCategory, (cat) {
      categoryController.text = cat?.name ?? "";
    });
    super.onInit();
  }

  void addMetaTag(String tagText) {
    documentMetaTagList.add(
      DocumentMetaTag(
        id: "", // New tags have no id yet (will be added on save)
        documentId: selectedDocumentId.value,
        metatag: tagText,
      ),
    );
  }

  void removeMetaTag(DocumentMetaTag tag) {
    documentMetaTagList.remove(tag);
  }

  final RxList<UserDropdownResponse> selectedUsers =
      <UserDropdownResponse>[].obs;
  final RxList<UserDropdownResponse> usersList = <UserDropdownResponse>[].obs;

  void selectRole(RoleDropdownResponse role) {
    if (!selectedRoles.any((r) => r.id == role.id)) {
      selectedRoles.add(role);
    }
  }

  void setInitialStatus(String? id) {
    if (id != null && documentStatusList.any((c) => c.id == id)) {
      selectedDocumentId.value = id;
    } else {
      selectedDocumentId.value = "";
    }
  }

  void removeRole(String roleId) {
    selectedRoles.removeWhere((role) => role.id == roleId);
  }

  void removeDocument(String documentId) {
    shareDocumentRoleList.removeWhere((role) => role!.documentId == documentId);
  }

  void increment() {
    selectedRetentionPeriod.value++;
  }

  void decrement() {
    if (selectedRetentionPeriod.value > 0) {
      selectedRetentionPeriod.value--;
    }
  }

  void clearSearch() {
    searchController.clear();
    showAll.value = false;
    if (hasFocus.value) showDropdown.value = true;
  }

  void clearUserSearch() {
    userSearchController.clear();
    showAll.value = false;
    if (hasFocus.value) showUserDropdown.value = true;
  }

  void selectUser(UserDropdownResponse user) {
    final isAlreadySelected = selectedUsers.any(
      (selectedUser) => selectedUser.id == user.id,
    );

    if (!isAlreadySelected) {
      selectedUsers.add(user);
    }
  }

  void removeUser(String userId) {
    selectedUsers.removeWhere((user) => user.id == userId);
  }

  bool isUserSelected(String userId) {
    return selectedUsers.any((user) => user.id == userId);
  }

  void toggleUser(UserDropdownResponse user) {
    if (isUserSelected(user.id!)) {
      removeUser(user.id!);
    } else {
      selectUser(user);
    }
  }

  void toggleRolesSpecifyPeriod(bool? v) {
    rolesSpecifyPeriod.value = v ?? false;
    if (!rolesSpecifyPeriod.value) {
      rolesStartDate.value = null;
      rolesEndDate.value = null;
    }
  }

  void setRolesStartDate(DateTime date) => rolesStartDate.value = date;

  void setRolesEndDate(DateTime date) => rolesEndDate.value = date;

  void toggleRolesAllowDownload(bool? v) =>
      rolesAllowDownload.value = v ?? false;

  final RxBool usersSpecifyPeriod = false.obs;
  final Rx<DateTime?> usersStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> usersEndDate = Rx<DateTime?>(null);
  final RxBool usersAllowDownload = false.obs;

  void toggleUsersSpecifyPeriod(bool? v) {
    usersSpecifyPeriod.value = v ?? false;
    if (!usersSpecifyPeriod.value) {
      usersStartDate.value = null;
      usersEndDate.value = null;
    }
  }

  void setUsersStartDate(DateTime date) => usersStartDate.value = date;

  void setUsersEndDate(DateTime date) => usersEndDate.value = date;

  void toggleUsersAllowDownload(bool? v) =>
      usersAllowDownload.value = v ?? false;

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "";

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();

    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final formattedHour = hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? "PM" : "AM";

    return "$day-$month-$year $formattedHour:$minute $period";
  }

  void updateClient(String? v) {
    if (v != null) selectedClientId.value = v;
  }

  void updateDocumentStatus(String? v) {
    if (v != null) selectedDocumentStatusId.value = v;
  }

  void updateCategory(CategoryDropdownResponse? v) {
    if (v != null) selectedCategory.value = v;
  }

  void updateRetentionPeriod(String? v) {
    if (v != null) selectedRetentionPeriod.value = int.parse(v);
  }

  void updateRetentionAction(int? v) {
    if (v != null) selectedRetentionAction.value = v;
  }

  void updateStorage(String? v) {
    if (v != null) selectedStorage.value = v;
  }

  void validateAndSave(BuildContext context) {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessageShow.show("All fields are required" ?? '');
      return;
    }

    addStartWorkFLow(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      context: context,
    );
  }

  RxList<DocumentResponse> documentsList = <DocumentResponse>[].obs;
  final RxBool isLoading = false.obs;
  void loadMoreDebounced() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      getDocuments(isLoadMoreRequest: true);
    });
  }
  Future<void> getDocuments({
    bool isLoadMoreRequest = false,
    bool? assignedDocuments,
    DocumentFilterRequest? appliedFilter,
  }) async {
    // 🛑 HARD GUARD – prevents parallel calls
    if (isLoading.value || isLoadMore.value) return;

    // 🛑 No more data
    if (isLoadMoreRequest && !hasMoreData) return;

    try {
      if (!isLoadMoreRequest) {
        // 🔄 Fresh load
        skip = 0;
        hasMoreData = true;
        documentsList.clear();

        if (assignedDocuments != null) {
          isAssignedDocs = assignedDocuments;
        }

        isLoading.value = true;
      } else {
        isLoadMore.value = true;
      }

      final filter = DocumentFilterRequest(
        pageSize: pageSize,
        skip: skip,
        assignedDocuments: isAssignedDocs,
        name: appliedFilter?.name,
        metaTags: appliedFilter?.metaTags,
        categoryId: appliedFilter?.categoryId,
        location: appliedFilter?.location,
        createDateString: appliedFilter?.createDateString,
        statusId: appliedFilter?.statusId,
        clientId: appliedFilter?.clientId,
      );

      final result = await documentsUseCase.getDocuments(filter);

      if (result != null && result.isNotEmpty) {
        documentsList.addAll(result.whereType<DocumentResponse>());
        skip += result.length; // ✅ correct pagination
      } else {
        hasMoreData = false; // ✅ stop loadMore
      }
    } catch (e) {
      debugPrint("Pagination Error: $e");
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }


  Future<RxList<CategoryDropdownResponse>> getCategory() async {
    try {
      isLoading.value = true;

      final result = await documentsUseCase.getCategory();

      if (result != null) {
        final nonNullUsers = result.whereType<CategoryDropdownResponse>();
        final treeCategories = <CategoryDropdownResponse>[].obs;
        for (var action in nonNullUsers) {
          treeCategories.add(action);
        }
        var data = buildCategoryTree(treeCategories);
        categoryList.assignAll(data);
      } else {
        categoryList.clear();
      }

      return categoryList;
    } catch (e) {
      debugPrint("Error fetching Category: $e");
      return categoryList;
    } finally {
      isLoading.value = false;
    }
  }

  Future<RxList<ClientDropdownResponse>> getClients({
    String? existingClientId,
  }) async {
    try {
      isLoading.value = true;

      final result = await documentsUseCase.getClients();

      if (result != null) {
        final nonNullUsers = result.whereType<ClientDropdownResponse>();
        clientList.assignAll(nonNullUsers);
      } else {
        clientList.clear();
      }

      // Auto-select if editing document
      if (existingClientId != null) {
        final match = clientList.firstWhere(
          (c) => c.id == existingClientId,
          orElse: () => ClientDropdownResponse(id: "", companyName: ""),
        );
        selectedClientId.value = match.id;
      }

      return clientList;
    } catch (e) {
      debugPrint("Error fetching clients: $e");
      return clientList;
    } finally {
      isLoading.value = false;
    }
  }

  Future<RxList<DocumentStatus>> getDocumentStatusList({
    String? existingStatusId,
  }) async {
    try {
      final result = await documentsUseCase.getDocumentStatus();

      if (result != null) {
        documentStatusList.assignAll(result.whereType<DocumentStatus>());
      } else {
        documentStatusList.clear();
      }
      if (existingStatusId != null) {
        final isMatched = documentStatusList.any(
          (e) => e.id == existingStatusId,
        );
        selectedDocumentStatusId.value = isMatched ? existingStatusId : "";
      }

      return documentStatusList;
    } catch (e) {
      debugPrint("Error fetching status: $e");
      return documentStatusList;
    } finally {
      isLoading.value = false;
    }
  }

  Future<RxList<UserDropdownResponse>> getUsers() async {
    try {
      isLoading.value = true;

      final result = await documentsUseCase.getUsers();

      if (result != null) {
        final nonNullUsers = result.whereType<UserDropdownResponse>();
        usersList.assignAll(nonNullUsers);
      } else {
        usersList.clear();
      }

      return usersList;
    } catch (e) {
      debugPrint("Error fetching users: $e");
      return usersList;
    } finally {
      isLoading.value = false;
    }
  }

  Future<RxList<RoleDropdownResponse>> getRoles() async {
    try {
      isLoading.value = true;
      final result = await documentsUseCase.getRoles();

      if (result != null) {
        final nonNullRoles = result.whereType<RoleDropdownResponse>();
        rolesList.assignAll(nonNullRoles);
      } else {
        rolesList.clear();
      }
      return rolesList;
    } catch (e) {
      debugPrint("Error fetching roles: $e");
      return rolesList;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getStartWorkFLowList() async {
    try {
      startWorkflowNameResponseList.value =
          (await documentsUseCase.starWorkFLowListApi() ?? [])
              .whereType<StartWorkflowResponse>()
              .toList();

      print("WorkFlowResponseList: ${startWorkflowNameResponseList.length}");

      // Set initial filtered list
      filteredStartWorkflowNameResponseList.assignAll(
        startWorkflowNameResponseList,
      );
    } catch (e, st) {
      print("WorkFlow error: $e\n$st");
    }
  }

  void searchWorkflow(String query) {
    if (query.isEmpty) {
      filteredStartWorkflowNameResponseList.assignAll(
        startWorkflowNameResponseList,
      );
    } else {
      filteredStartWorkflowNameResponseList.assignAll(
        startWorkflowNameResponseList.where(
          (item) =>
              (item.name ?? "").toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  Future<void> loadEditData(DocumentResponse? document) async {
    if (document == null) return;

    nameController.text = document.name ?? '';
    descriptionController.text = document.description ?? '';
    selectedRetentionPeriod.value = document.retentionPeriod ?? 0;

    selectedRetentionAction.value = document.retentionAction ?? 0;
    await getCategory();
    await getMetaTagList(document.id);
    categoryList.value = buildCategoryTree(categoryList);
    selectedCategory.value = categoryList.firstWhere(
      (cat) => cat.id == document.categoryId,
      orElse: () => CategoryDropdownResponse(id: '', name: ''),
    );
    selectedClientId.value = "";
    await getDocumentStatusList(existingStatusId: document.statusId);
    await getClients(existingClientId: document.clientId);
  }

  ClientDropdownResponse? get selectedClient {
    return clientList.firstWhereOrNull((c) => c.id == selectedClientId.value);
  }

  DocumentStatus? get selectedDocumentStatus {
    return documentStatusList.firstWhereOrNull(
      (c) => c.id == selectedDocumentStatusId.value,
    );
  }

  Future<void> saveDocument(BuildContext context) async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessageShow.show("Name is required");
      return;
    }
    if (selectedCategory.value == null || selectedCategory.value!.id.isEmpty) {
      ScaffoldMessageShow.show("Category is required");
      return;
    }

    try {
      isLoading.value = true;

      final request = DocumentRequest(
        uploadFile: selectedDocumentFile.value,
        name: nameController.text.trim(),
        categoryId: selectedCategory.value!.id,
        categoryName: selectedCategory.value!.name,
        location: selectedStorage.value,
        description: descriptionController.text.trim(),
        statusId: selectedDocumentStatusId.value,
        clientId: selectedClientId.value,
        retentionPeriod: selectedRetentionPeriod.value.toString(),
        retentionAction: selectedRetentionAction.value.toString(),
        htmlContent: "",
        documentMetaDatas: documentMetaTagList,

        // PASS MODEL directly
        documentRolePermissions: selectedRoles.map((role) {
          return {
            "id": "",
            "documentId": "",
            "roleId": role.id,
            "isTimeBound": rolesSpecifyPeriod.value,
            "startDate": rolesStartDate.value?.toIso8601String(),
            "endDate": rolesEndDate.value?.toIso8601String(),
            "isAllowDownload": rolesAllowDownload.value,
          };
        }).toList(),
        documentUserPermissions: selectedUsers.map((user) {
          return {
            "id": "",
            "documentId": "",
            "userId": user.id,
            "isTimeBound": usersSpecifyPeriod.value,
            "startDate": usersStartDate.value?.toIso8601String(),
            "endDate": usersEndDate.value?.toIso8601String(),
            "isAllowDownload": usersAllowDownload.value,
          };
        }).toList(),
      );

      final result = await documentsUseCase.addDocument(request);
      ScaffoldMessageShow.show("Document added successfully");
      clearData();
      routerController.router.pop();
    } catch (e) {
      debugPrint("Error save document: $e");
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editDocument(BuildContext context, String documentId) async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessageShow.show("Name is required");
      return;
    }

    if (selectedCategory.value == null || selectedCategory.value!.id.isEmpty) {
      ScaffoldMessageShow.show("Category is required");
      return;
    }

    try {
      isLoading.value = true;
      final request = EditDocumentRequest(
        id: documentId,
        categoryId: selectedCategory.value!.id,
        clientId: selectedClientId.value,
        statusId: selectedDocumentStatusId.value,
        retentionPeriod: selectedRetentionPeriod.value.toString(),
        retentionAction: selectedRetentionAction.value.toString(),
        description: descriptionController.text.trim(),
        name: nameController.text.trim(),
        documentMetaDatas: documentMetaTagList,
      );

      final result = await documentsUseCase.updateDocument(request);
      if (result.status == "Success") {
        operationEditAPi(documentId: documentId, operationName: "Modified");
        ScaffoldMessageShow.show(result.message ?? '');
        clearData();
      }
    } catch (e) {
      debugPrint("Error save document: $e");
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getDocumentSignatureList() async {
    isLoading.value = true;
    try {
      signatures.value =
          await documentsUseCase.getDocumentSignatureList(
            selectedDocumentId.value,
          ) ??
          [];
      print("SignaturesResponseList ${signatures.value.length}");
    } catch (e, st) {
      print("WorkFlow error: $e, StackTrace: $st");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMetaTagList(String documentId) async {
    isLoading.value = true;
    try {
      documentMetaTagList.clear();

      final result = await documentsUseCase.getDocumentMetaTagList(documentId);
      documentMetaTagList.assignAll(
        result?.whereType<DocumentMetaTag>().toList() ?? [],
      );
      print("DocumentMetaTagList ${documentMetaTagList.length}");
    } catch (e, st) {
      print("MetaTag error: $e, StackTrace: $st");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getShareDocumentRoleList() async {
    isLoading.value = true;
    try {
      shareDocumentRoleList.value =
          await documentsUseCase.shareRolePermissionListApi(
            selectedDocumentId.value,
          ) ??
          [];
      print("ShareDocumentRoleList ${shareDocumentRoleList.value.length}");
    } catch (e, st) {
      print("shareDocumentRole error: $e, StackTrace: $st");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> operationMailAPi({required String documentId}) async {
    try {
      final response = await documentsUseCase.operationNameApi(
        documentId,
        "Send_Email",
      );

      if (response.status == "Success") {
        return true;
      } else {
        ScaffoldMessageShow.show(response.message ?? "Failed to send email.");
        return false;
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
      return false;
    }
  }

  Future<ShareableLinkResponse?> getShareableLink(String documentId) async {
    final result = await documentsUseCase.getShareableLink(documentId);
    return result;
  }

  Future<bool> createShareLinkApi(
    ShareableLinkRequest shareableLinkRequest,
  ) async {
    isLoading.value = true;

    try {
      final response = await documentsUseCase.createShareableLink(
        shareableLinkRequest,
      );
      if (response.status == "Success") {
        ScaffoldMessageShow.show(response.message ?? '');
        return true;
      } else {
        ScaffoldMessageShow.show(response.message ?? '');
        return false;
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  bool isLinkExpired(String? expiryTime) {
    if (expiryTime == null || expiryTime.isEmpty) return false;

    DateTime expiryDate = DateTime.parse(expiryTime);
    DateTime now = DateTime.now();

    return now.isAfter(expiryDate);
  }
  Future<void> saveSignature(BuildContext context) async {
    if (signatureController.isEmpty) {
      print("No signature found ❌");
      return;
    }

    Uint8List? data = await signatureController.toPngBytes();
    if (data == null) return;

    signatureBytes.value = data;
    signatureBase64.value = base64Encode(data);

    print("Signature : ${selectedDocumentId.value}");
    addSignature(selectedDocumentId.value);
  }

  void clearSignature() {
    signatureController.clear();
    signatureBytes.value = null;
    signatureBase64.value = "";
  }

  Future<void> addSignature(String documentId) async {
    try {
      isLoading.value = true;

      final response = await documentsUseCase.documentSignatureApi(
        documentId,
        "data:image/png;base64,${signatureBase64.value}",
      );

      if (response.status == "Success") {
        ScaffoldMessageShow.show(response.message ?? '');
        clearSignature();
        routerController.router.pop();
      } else {
        ScaffoldMessageShow.show(response.message ?? '');
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteShareRole(String documentId, String shareType) async {
    try {
      // isLoading.value = true;

      final response = await documentsUseCase.shareDocumentPermissionDeleteApi(
        documentId,
        shareType,
      );

      if (response.status == "Success") {
        ScaffoldMessageShow.show(response.message ?? '');
        getShareDocumentRoleList();
        //  removeDocument(documentId);
      } else {
        ScaffoldMessageShow.show(response.message ?? '');
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      //  isLoading.value = false;
    }
  }

  Future<void> deleteSharableLink(
    String documentId,
    ShareableLinkController controller,
    BuildContext dialogContext,
  ) async {
    try {
      final response = await documentsUseCase.deleteSharableLinkApi(documentId);

      if (response.status == "Success") {
        ScaffoldMessageShow.show(response.message ?? '');
        if (dialogContext != null) {
          controller.onClear();
          Navigator.of(dialogContext).pop(); // closes AlertDialog
        }
      } else {
        ScaffoldMessageShow.show(response.message ?? '');
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      //  isLoading.value = false;
    }
  }

  Future<void> validateAndSaveComments(BuildContext context) async {
    if (commentsTextEditingController.text.isEmpty) {
      ScaffoldMessageShow.show("Comments field is required");
      return;
    }
    addComments(
      documentId: selectedDocumentId.value,
      description: commentsTextEditingController.text.trim(),
    );
  }

  Future<void> addComments({
    required String documentId,
    required String description,
  }) async {
    if (commentsTextEditingController.text.isEmpty) {
      ScaffoldMessageShow.show("Comments field is required");
      return;
    }
    try {
      //  isLoading.value = true;
      final response = await documentsUseCase.addCommentApi(
        documentId,
        description,
      );
      if (response.id.isNotEmpty) {
        ScaffoldMessageShow.show("Comment Added successfully");

        response.createdByName =
            '${authController.loginResponseResponse.value?.user?.firstName ?? ''}'
            '${authController.loginResponseResponse.value?.user?.lastName ?? ''}';

        print("Data : ${response.createdByName}");
        commentModelList.insert(0, response);
      }
      commentsTextEditingController.clear();
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCommentList(String documentId) async {
    try {
      isLoading.value = true;
      final result = await documentsUseCase.getCommentList(documentId);
      commentModelList.clear();
      if (result != null) {
        final nonNullUsers = result.whereType<CommentModel>();
        commentModelList.assignAll(nonNullUsers);
      }
    } catch (e) {
      debugPrint("Error fetching comment: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCommentApi({
    required String documentId,
    required String commentId,
  }) async {
    try {
      //  isLoading.value = true;

      final response = await documentsUseCase.deleteCommentApi(commentId);
      ScaffoldMessageShow.show("${response.message}");
      commentModelList.removeWhere((c) => c.id == commentId);
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveRoleShare({
    required DocumentSharePermissionRequest request,
  }) async {
    try {
      isLoading.value = true;

      final response = await documentsUseCase.shareDocumentPermissionRequestApi(
        request,
      );

      ScaffoldMessageShow.show(response.message ?? '');
      getShareDocumentRoleList();
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadFile() async {
    if (selectedDocumentFile.value == null) {
      ScaffoldMessageShow.show("Please Select File");
      return;
    }

    try {
      isLoading.value = true;

      final response = await documentsUseCase.uploadNewVersionApi(
        selectedDocumentId.value,
        "local",
        selectedDocumentFile.value!,
      );

      ScaffoldMessageShow.show(response.message ?? '');
      routerController.router.pop();
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> operationAPi({
    required String documentId,
    required String operationName,
  }) async {
    try {
      isLoading.value = true;

      final response = await documentsUseCase.operationNameApi(
        documentId,
        operationName,
      );

      if (response.status == "Success") {
        getDocuments();
      } else {
        ScaffoldMessageShow.show("${response.message}");
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> operationEditAPi({
    required String documentId,
    required String operationName,
  }) async {
    try {
      isLoading.value = true;

      final response = await documentsUseCase.editDocumentApi(
        documentId,
        operationName,
      );
      getDocuments(assignedDocuments: false);
      routerController.router.pop();
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDocumentApi({
    required String documentId,
    required String documentType,
  }) async {
    try {
      isLoading.value = true;

      final response = await documentsUseCase.deleteDocumentApi(
        documentId,
        documentType,
      );
      operationAPi(documentId: documentId, operationName: documentType);
      ScaffoldMessageShow.show("${response.message}");
      routerController.router.pop();
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> shareAPi({required String documentId}) async {
    try {
      isLoading.value = true;

      ShareDocumentRequest shareDocumentRequest = ShareDocumentRequest(
        documentId: documentId,
        userId: PreferenceUtils.getString(AppConstants.USER_ID),
        startDate: DateTime.now(),
        isAllowDownload: false,
        isTimeBound: false,
        createdBy: PreferenceUtils.getString(AppConstants.USER_NAME),
        modifiedBy: PreferenceUtils.getString(AppConstants.USER_NAME),
      );

      final response = await documentsUseCase.shareDocumentRequestApi(
        shareDocumentRequest,
      );

      if (response.status == "Success") {
        //ScaffoldMessageShow.show("${response.message}");
        // back to list screen
        //getShareDocumentRoleList();
        routerController.router.pop();
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addStartWorkFLow({
    required String name,
    required String description,
    required BuildContext context,
  }) async {
    try {
      isLoading.value = true;

      final response = await documentsUseCase.starWorkFLowApi(
        name,
        description,
      );

      if (response.status == "Success") {
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

  Future<void> startWorkFlowCreate(String documentId, String workFlowId) async {
    try {
      isLoading.value = true;

      final response = await documentsUseCase.starWorkFLowCreateApi(
        documentId,
        workFlowId,
      );
      if (response.status == "Success") {
        ScaffoldMessageShow.show(response.message ?? '');
      } else {
        ScaffoldMessageShow.show(response.message ?? '');
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void openCategorySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: CategoryTreeView(
            categories: categoryList,
            selectedCategoryId: selectedCategory.value?.id,
            onSelected: (cat) {
              selectedCategory.value = cat;
              categoryController.text = cat.name;
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  List<CategoryDropdownResponse> buildCategoryTree(
    List<CategoryDropdownResponse> categories,
  ) {
    final Map<String, CategoryDropdownResponse> map = {
      for (var category in categories) category.id: category,
    };

    final List<CategoryDropdownResponse> roots = [];

    for (var category in categories) {
      if (category.parentId == null) {
        roots.add(category);
      } else {
        final parent = map[category.parentId];
        if (parent != null) {
          parent.children.add(category);
        }
      }
    }

    return roots;
  }

  Future<void> deleteCommentDialog(String documentId,String commentId, BuildContext context) async {
    _showCommentDeleteDialog(
      context,
      documentId,commentId,
      " Are you sure you want to delete?",

    );
  }

  void _showCommentDeleteDialog(
      BuildContext context,
      String documentId,
      String commentId,
      String title,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          actions: [
            TextButton(
              child: const Text("No", style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // close dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: isLoading.value?CircularProgressIndicator(): Text("Yes", style: TextStyle(color: Colors.white)),
              onPressed: () {

                deleteCommentApi(documentId: documentId, commentId: commentId);
                Navigator.of(dialogContext).pop();

              },
            ),
          ],
        );
      },
    );
  }
  void clearData() {
    selectedStorage.value = "Local Disk (Default)";
    nameController.text = "";
    descriptionController.text = "";
    selectedDocumentStatusId.value = "";
    selectedClientId.value = null;
    selectedRetentionPeriod.value = 0;
    selectedRetentionAction.value = 0;
    selectedDocument.value = null;
    selectedDocumentId.value = "";
    selectedDocumentFile.value = null;
    selectedCategory.value = null;
    rolesStartDate.value = null;
    rolesEndDate.value = null;
    usersStartDate.value = null;
    usersEndDate.value = null;
    usersAllowDownload.value = false;
    rolesAllowDownload.value = false;
    rolesSpecifyPeriod.value = false;
    usersSpecifyPeriod.value = false;
    documentMetaTagList.value = [];
    documentMetaTagList.value.clear();
    commentModelList.value.clear();
    selectedRoles.clear();
    selectedUsers.clear();
  }

  @override
  void onClose() {
    signatureController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    commentsTextEditingController.dispose();
    super.onClose();
  }
}
