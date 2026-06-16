import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/presentation/user/controllers/auth_controller.dart';
import 'package:docuflow/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:docuflow/edit_profile_screen.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/router_controller.dart';
import '../../../constants/PreferenceUtils.dart';
import '../../../core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({Key? key}) : super(key: key);

   final RouterController routerController = Get.find<RouterController>();

  AuthController controller = Get.put(Get.find<AuthController>());

  // 🔹 Show logout dialog
   void _showLogoutDialog(BuildContext context) {
     Get.dialog(
       AlertDialog(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(16),
         ),
         title: Text(
           "Logout",
           style: TextStyle(
             fontWeight: FontWeight.bold,
             color: Theme.of(context).colorScheme.onSurface,
           ),
         ),
         content: Text(
           "Are you sure you want to logout?",
           style: TextStyle(
             color: Theme.of(context).colorScheme.onSurfaceVariant,
           ),
         ),
         actions: [
           TextButton(
             onPressed: () => Get.back(),
             child: Text(
               "Cancel",
               style: TextStyle(
                 color: Theme.of(context).colorScheme.primary,
               ),
             ),
           ),

           ElevatedButton(
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.red,
               foregroundColor: Colors.white,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(12),
               ),
             ),
             onPressed: () {

                PreferenceUtils.setBool(AppConstants.IS_LOGIN, false);
                PreferenceUtils.setString(AppConstants.USER_NAME, "");
               PreferenceUtils.setString(AppConstants.PASSWORD, "");
                Get.back();
                GoRouter.of(context).go(AppScreens.loginScreen);

             },
             child: const Text("Logout"),
           ),
         ],
       ),
       barrierDismissible: false,
     );
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: Obx(()=>
       SingleChildScrollView(
          child:  controller.loginResponseResponse.value==null?SizedBox.shrink():Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Bigger Logo
              Image.asset(
                'assets/images/docuflow_logo.jpg',
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 24),

              Obx(() => Text(
                '${controller.loginResponseResponse.value?.user?.firstName ?? ''} '
                    '${controller.loginResponseResponse.value?.user?.lastName ?? ''}',
              )),
              Text(
                '${controller.loginResponseResponse.value!.user!.email}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.edit, color: Colors.red),
                        title: const Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.lock_reset, color: Colors.red),
                        title: const Text(
                          'Reset Password',
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
