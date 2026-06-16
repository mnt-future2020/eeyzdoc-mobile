import 'dart:convert';

import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/core/utils/scaffold_message.dart';
import 'package:docuflow/presentation/user/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/PreferenceUtils.dart';
import 'core/constants/app_constants.dart';
import 'data/models/response/login_response.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();
  final routerController = Get.find<RouterController>();
  bool _isLoading = false;


  Future<void> _editProfile() async {
    if (!_formKey.currentState!.validate()) return;
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    setState(() => _isLoading = true);
    var response = await authController.editProfile(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      email: email,
    );
    setState(() => _isLoading = false);
    if (response.status == "success") {
      ScaffoldMessageShow.show( response.message ?? '');

      var user = authController.loginResponseResponse.value!.user!;
      user.firstName = firstName;
      user.lastName = lastName;
      user.email = email;
      user.phoneNumber = phoneNumber;
      authController.loginResponseResponse.refresh();

      Future.delayed(const Duration(seconds: 1), () {
        _formKey.currentState?.reset();
      });
      Navigator.of(context).pop();
    } else {
      ScaffoldMessageShow.show( response.message ?? '');
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
     var user= authController.loginResponseResponse.value!.user;
     _firstNameController.text = user!.firstName??'';
     _lastNameController.text = user.lastName??'';
     _emailController.text = user.email??'';
     _phoneController.text = user.phoneNumber ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Form added here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile picture editable
          /*    Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 15,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),*/
              const SizedBox(height: 28),

              // First Name
              TextFormField(
                controller: _firstNameController,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: const TextStyle(fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "First name required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Last Name
              TextFormField(
                controller: _lastNameController,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: const TextStyle(fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Last name required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Email
              TextFormField(
                controller: _emailController,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: const TextStyle(fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 10) {
                    return "Enter valid phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFEF5350),
                        Color(0xFFD32F2F),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _editProfile,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Save Change',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // Save button

            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> splitName(String fullName) {
    fullName = fullName.trim();

    if (fullName.isEmpty) {
      return {'first': '', 'last': ''};
    }

    // Replace multiple spaces with single space
    fullName = fullName.replaceAll(RegExp(r'\s+'), ' ');

    List<String> parts = fullName.split(' ');

    if (parts.length == 1) {
      return {'first': parts[0], 'last': ''};
    }

    return {
      'first': parts.first,
      'last': parts.sublist(1).join(' ').trim(),
      // Combine remaining names safely
    };
  }
}
