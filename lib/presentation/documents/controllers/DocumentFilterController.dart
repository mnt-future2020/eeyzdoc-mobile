import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/request/document_filter_request.dart';
import '../../../data/models/response/CategoryDropDownResponse.dart';
import '../../../data/models/response/clientDropdownResponse.dart';
import '../../../data/models/response/document_status.dart';
import '../../../widgets/dropdowns/CategoryTreeView.dart';

class DocumentFilterController extends GetxController {
  var searchName = ''.obs;
  var metaTags = ''.obs;
  final TextEditingController searchNameCtrl = TextEditingController();
  final TextEditingController metaTagsCtrl = TextEditingController();
  var documentAssign = RxnBool();

  var selectedLocation = Rxn<String>();
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var documentsList = <dynamic>[].obs;
  final docController = Get.find<DocumentsController>();
  final categoryController = TextEditingController();
  final selectedCategory = Rx<CategoryDropdownResponse?>(null);
  final clientList = <ClientDropdownResponse>[].obs;
  final documentStatusList = <DocumentStatus>[].obs;
  final categoryList = <CategoryDropdownResponse>[].obs;
  var selectedDocumentStatusId = RxnString();
  var selectedClientId = RxnString();

  @override
  void onReady() async {
    super.onReady();

    await Future.wait([
      docController.getDocumentStatusList(),
      docController.getCategory(),
      docController.getClients(),
    ]);

    categoryList.assignAll(docController.categoryList);
    clientList.assignAll(docController.clientList);
    documentStatusList.assignAll(docController.documentStatusList);
  }


  @override
  void onInit() {
    ever(selectedCategory, (cat) {
      categoryController.text = cat?.name ?? "";
    });

    super.onInit();
  }

  void setDocumentAssign(bool? id) {
    documentAssign.value = id ?? false;
  }
  Future<void> fetchDocuments() async {
    searchName.value=searchNameCtrl.text.toString();
    metaTags.value=metaTagsCtrl.text.toString();
    final filter = DocumentFilterRequest(
      name: searchNameCtrl.text.trim(),
      metaTags: metaTagsCtrl.text.trim(),
      categoryId: selectedCategory.value?.id,
      location: selectedLocation.value,
      createDateString: startDate.value != null
          ? startDate.value!.toIso8601String()
          : "",
      statusId: selectedDocumentStatusId.value,
      clientId: selectedClientId.value,
    );

    print("Client Id: ${selectedClientId.value}");
    docController.getDocuments(
      appliedFilter: filter,
      assignedDocuments: documentAssign.value
    );

  }
  void openCategorySelector(BuildContext context) {
    Get.bottomSheet(
      SizedBox(
        height: 400,
        child: CategoryTreeView(
          categories: categoryList,
          selectedCategoryId: selectedCategory.value?.id,
          onSelected: (cat) {
            selectedCategory.value = cat;
            categoryController.text = cat.name;
            fetchDocuments();
            Get.back(); // close bottom sheet
          },
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }



  void resetFilters() {
    searchName.value = '';
    metaTags.value = '';
    selectedCategory.value = null;
    selectedLocation.value = null;
    selectedDocumentStatusId.value = null;
    selectedClientId.value = null;
    startDate.value = null;
    fetchDocuments();
  }

}
