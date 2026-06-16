import 'package:docuflow/app/routes/bottom_tab_nav_bar.dart';
import 'package:docuflow/app/routes/drawer_nav_bar.dart';
import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/data/models/response/document_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';
import 'package:docuflow/forgot_password_screen.dart';
import 'package:docuflow/presentation/common/downloads_screen.dart';
import 'package:docuflow/presentation/common/file_web_view_viewer.dart';
import 'package:docuflow/presentation/documents/bindings/documents_binding.dart';
import 'package:docuflow/presentation/documents/screens/add_document_screen.dart';
import 'package:docuflow/presentation/documents/screens/documentdetails/comments_screen.dart';
import 'package:docuflow/presentation/documents/screens/documentdetails/details/document_details.dart';
import 'package:docuflow/presentation/documents/screens/documentdetails/start_workflow_screen.dart';
import 'package:docuflow/presentation/expired/bindings/expired_binding.dart';
import 'package:docuflow/presentation/filerequest/page/file_request_add_page.dart';
import 'package:docuflow/presentation/main/bindings/dashboard_binding.dart';
import 'package:docuflow/presentation/main/screens/dashboard_screen.dart';
import 'package:docuflow/presentation/documents/screens/all_documents_screen.dart';
import 'package:docuflow/presentation/reminder/reminder_add_screen.dart';
import 'package:docuflow/presentation/user/bindings/auth_binding.dart';
import 'package:docuflow/presentation/user/screens/login_screen.dart';
import 'package:docuflow/presentation/user/screens/profile_screen.dart';
import 'package:docuflow/presentation/user/screens/splash_screen_page.dart';
import 'package:docuflow/presentation/reminder/reminders_screen.dart';
import 'package:docuflow/presentation/versionHistory/version_history_page.dart';
import 'package:docuflow/presentation/workflow/bindings/work_flow_binding.dart';
import 'package:docuflow/presentation/workflow/pages/my_work_flow_list_page.dart';
import 'package:docuflow/presentation/workflow/pages/work_flow_details_page.dart';
import 'package:docuflow/presentation/workflow/pages/work_flow_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/request/CommentArgs.dart';
import '../../data/models/response/file_request_response.dart';
import '../../presentation/archived/bindings/archived_binding.dart';
import '../../presentation/archived/page/archived_documents_screen.dart';
import '../../presentation/common/mail_composer_screen.dart';
import '../../presentation/documents/screens/documentdetails/signature/document_signature_screen.dart';
import '../../presentation/documents/screens/documentdetails/upload_new_vesion_page.dart';
import '../../presentation/expired/page/expired_documents_screen.dart';
import '../../presentation/filerequest/bindings/file_request_binding.dart';
import '../../presentation/filerequest/page/file_request_page.dart';
import '../../presentation/filerequest/page/file_request_view_page.dart';
import '../../presentation/main/screens/notifications_screen.dart';
import '../../presentation/master/bindings/master_binding.dart';
import '../../presentation/master/screens/add_client_screen.dart';
import '../../presentation/master/screens/clients_list_screen.dart';
import '../../presentation/master/screens/edit_client_screen.dart';
import '../../presentation/reminder/bindings/reminder_binding.dart';
import '../../presentation/share/share_role_list_screen.dart';

Page<T> slidePageBuilder<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  String offset = "IN",
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 900),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetValue = offset == "IN"
          ? const Offset(1, 0)
          : const Offset(0, 1);

      return SlideTransition(
        position: Tween<Offset>(
          begin: offsetValue,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}

GoRouter createRouter(RouterController controller) {
  return GoRouter(
    navigatorKey: controller.appNavigatorKey,
    initialLocation: AppScreens.splashScreen,
    routes: [

      GoRoute(
        path: AppScreens.splashScreen,
        builder: (context, state) {
          MasterBinding().dependencies();
          return SplashScreenPage();
        },
      ),
      GoRoute(
        path: AppScreens.loginScreen,
        builder: (context, state) {
          AuthBinding().dependencies();
          return LoginScreen();
        },
      ),

      GoRoute(
        path: AppScreens.forgotScreen,
        builder: (context, state) {
          AuthBinding().dependencies();
          return ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: AppScreens.addDocumentScreen,
        pageBuilder: (context, state) {
          DocumentsBinding().dependencies();
          final details = state.extra as DocumentResponse?;
          return slidePageBuilder(
            context: context,
            state: state,
            child: AddDocumentScreen(documentResponse: details),
          );
        },
      ),
      GoRoute(
        path: AppScreens.notificationsScreen,
        builder: (context, state) {
          DashboardBinding().dependencies();
          return NotificationsScreen();
        },
      ),

      GoRoute(
        path: AppScreens.addClientScreen,
        pageBuilder: (context, state) {
          return slidePageBuilder(
            context: context,
            state: state,
            child: AddClientScreen(),
          );
        },
      ),

      GoRoute(
        path: AppScreens.editClientScreen,
        pageBuilder: (context, state) {
          return slidePageBuilder(
            context: context,
            state: state,
            child: EditClientScreen(),
          );
        },
      ),
      GoRoute(
        path: AppScreens.profileScreen,
        pageBuilder: (context, state) {
          AuthBinding().dependencies();
          return slidePageBuilder(
            context: context,
            state: state,
            child: ProfileScreen(),
          );
        },
      ),
      GoRoute(
        path: AppScreens.remindersAddScreen,
        pageBuilder: (_, state) {
          ReminderBinding().dependencies();

          final extra = state.extra as Map<String, String?>?;
          final reminderId = extra?['reminderId'];
          final documentId = extra?['documentId'];

          return NoTransitionPage(
            child: ReminderAddScreen(
              editingReminderId: reminderId,
              documentId: documentId,
            ),
          );
        },
      ),
      GoRoute(
        path: AppScreens.emailComposerScreen,
        builder: (context, state) {
          DocumentDetailsBinding().dependencies();
          return MailComposerScreen();
        },
      ),

      GoRoute(
        path: AppScreens.fileWebViewViewer,
        pageBuilder: (context, state) {
          final fileUrl = state.uri.queryParameters['url'] ?? '';

          return NoTransitionPage(child: FileWebViewViewer(url: fileUrl));
        },
      ),


      GoRoute(
        path: AppScreens.documentDetailsScreen,
        pageBuilder: (context, state) {
          DocumentsBinding().dependencies();
          final details = state.extra as DocumentResponse?;
          return slidePageBuilder(
            context: context,
            state: state,
            child: DocumentDetailsScreen(documentResponse: details!),
          );
        },
      ),

      GoRoute(
        path: AppScreens.fileDetailsScreen,
        pageBuilder: (context, state) {
          FileRequestBinding().dependencies();
          final fileId = state.extra as String?;

          return slidePageBuilder(
            context: context,
            state: state,
            child: FileRequestViewPage(fileId: fileId??'',),
          );
        },
      ),
      GoRoute(
        path: AppScreens.downloadsScreen,
        pageBuilder: (context, state) {
          return slidePageBuilder(
            context: context,
            state: state,
            child: DownloadsScreen(),
          );
        },
      ),
      GoRoute(
        path: AppScreens.versionHistory,
        pageBuilder: (context, state) {
          DocumentDetailsBinding().dependencies();
          final details = state.extra as DocumentResponse?;
          return NoTransitionPage(
            child: VersionHistoryPage(documentResponse: details!,),
          );
        },
      ),

      ShellRoute(
        builder: (_, __, child) => DrawerNavBar(child: child),
        routes: [
          ShellRoute(
            builder: (_, __, child) => BottomNavBar(child: child),
            routes: [
              GoRoute(
                path: AppScreens.dashboardScreen,
                pageBuilder: (_, state) {
                  DashboardBinding().dependencies();
                  return NoTransitionPage(child: DashboardScreen());
                },
              ),

              GoRoute(
                path: AppScreens.filesScreen,
                pageBuilder: (_, state) => NoTransitionPage(
                  child: const Center(child: Text("Files Screen")),
                ),
                // NoTransitionPage(child: const FilesScreen()),
              ),

              GoRoute(
                path: AppScreens.workFlowsScreen,
                pageBuilder: (_, state) {
                  WorkFlowBinding().dependencies();
                  return NoTransitionPage(child: WorkFlowListPage(myWorkFlow: false));
                },
              ),
              GoRoute(
                path: AppScreens.myWorkFlowScreen,
                pageBuilder: (_, state) {
                  WorkFlowBinding().dependencies();
                  return NoTransitionPage(child: MyWorkFlowListPage(myWorkFlow: true));
                },
              ),

              GoRoute(
                path: AppScreens.workFlowsDetailsScreen,
                pageBuilder: (context, state) {

                  final item = state.extra as WorkFlowDetailsResponse?;

                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: WorkFlowDetailsPage(details: item!),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  );
                },
              ),
              GoRoute(
                path: AppScreens.remindersScreen,
                pageBuilder: (_, state) {
                  ReminderBinding().dependencies();
                  return NoTransitionPage(child: RemindersScreen());
                },
              ),

              GoRoute(
                path: AppScreens.fileRequestScreen,
                pageBuilder: (context, state) {
                  FileRequestBinding().dependencies();
                  return NoTransitionPage(child: FileRequestPage());
                },
              ),
            ],
          ),
          GoRoute(
            path: AppScreens.allDocumentsScreen,
            pageBuilder: (_, state) {
              DocumentsBinding().dependencies();
              final isMyDocs = state.extra as bool? ?? false;
              return NoTransitionPage(
                child: AllDocumentsScreen(documentAssign: isMyDocs),
              );
            },
          ),
          GoRoute(
            path: AppScreens.fileRequestAddScreen,
            pageBuilder: (_, state) {
              FileRequestBinding().dependencies();
              final data = state.extra as FileRequestResponse?;
              return NoTransitionPage(child: AddFileRequestPage(data: data));
            },
          ),
          GoRoute(
            path: AppScreens.myDocumentsScreen,
            pageBuilder: (_, state) {
              DocumentsBinding().dependencies();
              return NoTransitionPage(
                child: AllDocumentsScreen(documentAssign: true),
              );
            },
          ),
          GoRoute(
            path: AppScreens.documentSignatureScreen,
            pageBuilder: (_, __) {
              DocumentsBinding().dependencies();
              return NoTransitionPage(child: DocumentSignatureScreen());
            },
          ),
          GoRoute(
            path: AppScreens.documentShareListScreen,
            pageBuilder: (_, __) {
              DocumentsBinding().dependencies();
              return NoTransitionPage(child: ShareRoleListScreen());
            },
          ),
          GoRoute(
            path: AppScreens.startWorkFlowScreen,
            pageBuilder: (_, __) {
              DocumentsBinding().dependencies();
              return NoTransitionPage(child: StartWorkflowScreen());
            },
          ),
          GoRoute(
            path: AppScreens.uploadNewVersion,
            pageBuilder: (_, __) {
              DocumentsBinding().dependencies();
              return NoTransitionPage(child: UploadFilePage());
            },
          ),
          GoRoute(
            path: AppScreens.commentsScreen,
            pageBuilder: (context, state) {
              DocumentsBinding().dependencies();
              final args = state.extra as CommentArgs;
              return NoTransitionPage(
                child: CommentsScreen(
                 commentArgs: args,
                ),
              );
            },
          ),



          GoRoute(
            path: AppScreens.archivedDocumentsScreen,
            pageBuilder: (context, state) {
              ArchivedBinding().dependencies();
              return NoTransitionPage(
                child: ArchivedDocumentsScreen(),
              );
            },
          ),
          GoRoute(
            path: AppScreens.expiredDocumentsScreen,
            pageBuilder: (context, state) {
              ExpiredBinding().dependencies();
              return NoTransitionPage(
                child: ExpiredDocumentsScreen(),
              );
            },
          ),
          GoRoute(
            path: AppScreens.clientsScreen,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: ClientsListScreen());
            },
          ),
        ],
      ),
    ],
  );
}
