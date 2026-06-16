import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/core/utils/scaffold_message.dart';
import 'package:docuflow/presentation/user/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _currentController = TextEditingController(text: "");
  final _newController = TextEditingController(text: "");
  final _confirmController = TextEditingController(text: "");
  final authController = Get.find<AuthController>();
  final routerController = Get.find<RouterController>();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    String currentPassword = _currentController.text.trim();
    String newPassword = _newController.text.trim();
    String confirmPassword = _confirmController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessageShow.show( "Passwords do not match.");
      return;
    }
    setState(() => _isLoading = true);

    var response = await authController.changePassword(
      oldPassword: currentPassword,
      newPassword: newPassword,
    );
    setState(() => _isLoading = false);

    if (response.status == "success") {
      ScaffoldMessageShow.show( response.message ?? '');

      Future.delayed(const Duration(seconds: 1), () {
        _formKey.currentState?.reset();
        PreferenceUtils.setBool(AppConstants.IS_LOGIN, false);
        PreferenceUtils.setString(AppConstants.AUTH_TOKEN, "");
        PreferenceUtils.setString(AppConstants.USER_NAME, "");
        PreferenceUtils.setString(AppConstants.PASSWORD, "");
        routerController.router.go(AppScreens.loginScreen);
      });
    } else {
      ScaffoldMessageShow.show( response.message ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fieldFontSize = 12.0; // reduced font size
    const fieldGap = SizedBox(height: 28); // increased gap

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Reset Password',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lock icon header
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.red.shade50,
                child: const Icon(
                  Icons.lock,
                  color: Colors.black87, // changed color
                  size: 40,
                ),
              ),
              const SizedBox(height: 30),

              // Current Password
              TextFormField(
                controller: _currentController,
                obscureText: _obscureCurrent,
                style: TextStyle(fontSize: fieldFontSize),
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(fontSize: fieldFontSize),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrent = !_obscureCurrent;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter current password';
                  }
                  return null;
                },
              ),
              fieldGap,

              // New Password
              TextFormField(
                controller: _newController,
                obscureText: _obscureNew,
                style: TextStyle(fontSize: fieldFontSize),
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(fontSize: fieldFontSize),
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNew = !_obscureNew;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              fieldGap,

              // Confirm Password
              TextFormField(
                controller: _confirmController,
                obscureText: _obscureConfirm,
                style: TextStyle(fontSize: fieldFontSize),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(fontSize: fieldFontSize),
                  prefixIcon: const Icon(Icons.lock_person),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your password';
                  }
                  if (value != _newController.text) {
                    return 'Passwords do not match';
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
                      onPressed: _resetPassword,
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

            ],
          ),
        ),
      ),
    );
  }
}
