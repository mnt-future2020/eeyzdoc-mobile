import 'package:docuflow/presentation/master/controllers/master_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  late MasterController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MasterController>();
    controller.companyNameCtrl.clear();
    controller.contactPersonCtrl.clear();
    controller.emailCtrl.clear();
    controller.phoneCtrl.clear();
    controller.addressCtrl.clear();
  }

  @override
  void dispose() {
    controller.companyNameCtrl.clear();
    controller.contactPersonCtrl.clear();
    controller.emailCtrl.clear();
    controller.phoneCtrl.clear();
    controller.addressCtrl.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Add Client",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _sectionTitle("Client Details"),
              const SizedBox(height: 12),

              _inputField(
                controller: controller.companyNameCtrl,
                label: "Company Name",
                hint: "Enter company name",
                keyboard: TextInputType.text,
                required: true,
              ),
              const SizedBox(height: 16),

              _inputField(
                controller: controller.contactPersonCtrl,
                label: "Contact Person",
                hint: "Enter contact person",
                keyboard: TextInputType.text,
                required: true,
              ),
              const SizedBox(height: 16),

              _inputField(
                controller: controller.emailCtrl,
                label: "Email",
                hint: "Enter email",
                keyboard: TextInputType.emailAddress,
                required: true,
                validator: (value) =>
                _validateEmail(value) ? null : "Enter valid email",
              ),
              const SizedBox(height: 16),

              _inputField(
                controller: controller.phoneCtrl,
                label: "Phone Number",
                hint: "Enter phone number",
                keyboard: TextInputType.phone,
                maxLength: 10,
                required: true,
                validator: (value) => _validatePhone(value)
                    ? null
                    : "Enter valid 10-digit number",
              ),
              const SizedBox(height: 16),

              _inputField(
                controller: controller.addressCtrl,
                label: "Address",
                hint: "Enter address",
                keyboard: TextInputType.streetAddress,
                maxLines: 3,
                required: false,
              ),
              const SizedBox(height: 24),

              _actionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(
                () => ElevatedButton(
              onPressed: controller.isAdding.value
                  ? null
                  : () => controller.addClient(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: controller.isAdding.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboard,
    bool required = false,
    int? maxLength,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: required ? "$label *" : label,
        hintText: hint,
        counterText: maxLength != null ? "" : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator:
      validator ??
              (value) {
            if (required && (value == null || value.trim().isEmpty)) {
              return "$label is required";
            }
            return null;
          },
    );
  }

  bool _validateEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  bool _validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }
}