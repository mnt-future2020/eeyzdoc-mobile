import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/data/models/request/client_request.dart';
import 'package:docuflow/data/models/response/client_response.dart';
import 'package:docuflow/domain/usecases/master_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MasterController extends GetxController {
  final MasterUseCase masterUseCase;

  MasterController({required this.masterUseCase});

  RxBool isLoading = false.obs;
  RxBool isAdding = false.obs;

  RxList<ClientResponse> clients = <ClientResponse>[].obs;

  final contactPersonCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final companyNameCtrl = TextEditingController();
  RxString selectedClientId = "".obs;

  final routerController = Get.find<RouterController>();

  Future<void> loadClients() async {
    try {
      isLoading.value = true;
      final result = await masterUseCase.getClientList();
      clients.value = result?.whereType<ClientResponse>().toList() ?? [];
    } finally {
      isLoading.value = false;
    }
  }

  void openEditClient(ClientResponse client) {
    companyNameCtrl.text = client.companyName ?? "";
    contactPersonCtrl.text = client.contactPerson ?? "";
    emailCtrl.text = client.email ?? "";
    phoneCtrl.text = client.phoneNumber ?? "";
    addressCtrl.text = client.address ?? "";

    selectedClientId.value = client.id ?? "";

    routerController.router.push(AppScreens.editClientScreen);
  }

  Future<void> updateClient(BuildContext context) async {
    if (!_validateInputs(context)) return;

    isAdding.value = true;

    final request = ClientRequest(
      id: selectedClientId.value,
      contactPerson: contactPersonCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phoneNumber: phoneCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      companyName: companyNameCtrl.text.trim(),
    );

    final result = await masterUseCase.editClient(
      selectedClientId.value,
      request,
    );

    isAdding.value = false;

    if (result != null) {
      routerController.router.pop();
      loadClients();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Client updated successfully")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to update client")));
    }
  }

  Future<void> addClient(BuildContext context) async {
    if (!_validateInputs(context)) return;

    isAdding.value = true;

    final request = ClientRequest(
      contactPerson: contactPersonCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phoneNumber: phoneCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      companyName: companyNameCtrl.text.trim(),
    );

    final response = await masterUseCase.addClient(request);

    isAdding.value = false;

    if (response != null) {
      routerController.router.pop();
      loadClients();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Client added successfully")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add client")));
    }
  }

  Future<void> deleteClient(String id, BuildContext context) async {
    await masterUseCase.deleteClient(id);
    loadClients();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Client deleted")));
  }

  bool _validateInputs(BuildContext context) {
    if (contactPersonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter contact person")));
      return false;
    }
    if (emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter email")));
      return false;
    }
    if (phoneCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter phone number")));
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    contactPersonCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    companyNameCtrl.dispose();
    super.onClose();
  }
}
