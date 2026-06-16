// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:docuflow/core/manager/role_manager.dart';
// import 'package:senzsafe/domain/entities/user_entity.dart';
// import 'package:senzsafe/presentation/providers/user/auth_provider.dart';

// class PermissionUtils {
//   static bool canAccessFeature(WidgetRef ref, String permission) {
//     final authState = ref.read(authViewModelProvider);
//     final authDetail = authState.authDetail;

//     final UserEntity? user = authDetail.value;

//     return RoleManager.hasPermission(user!.role, permission);
//   }

//   static void guardAccess(
//     BuildContext context,
//     WidgetRef ref,
//     String permission,
//   ) {
//     if (!canAccessFeature(ref, permission)) {
//       Navigator.of(context).pop();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('You do not have permission to access this feature'),
//         ),
//       );
//       throw Exception('Unauthorized access attempted');
//     }
//   }
// }
