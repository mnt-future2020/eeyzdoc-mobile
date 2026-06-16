class AppConstants {
  static String appState = 'dev';
  static String currentUser = 'current_user';
  static String hiveBoxName = "docu_flow_db_01";
  static String appKey = '';
  static String baseUrl = 'https://eezydoc.v7testsite.in';
  static const String AUTH_TOKEN = "is_auth_token";
  static const String IS_LOGIN = "is_login";
  static const String LOGIN_RESPONSE = "login_response";
  static const String USER_ID = "user_id";
  static const String USER_NAME = "user_name";
  static const String PASSWORD = "password";
  static const String IS_CONTENT_TYPE = "application/x-www-form-urlencoded";
  static const String IS_BEARER = "Bearer";

  //Request APi
  static const String login = "/api/auth/login";
  static const String logout = "/api/auth/logout";
  static const String changePassword = "/api/user/changepassword";
  static const String editProfile = "/api/users/profile";
  static const String forgotPassword = "/api/user/forgotPassword";
  static const String reminderList = "/api/reminder/all";
  static const String workFLowList = "/api/documentWorkflow";
  static const String myWorkFLowList = "/api/my-workflow";
  static const String getDocumentByCategory = "/api/Dashboard/GetDocumentByCategory";
  static const String documentShareableLink = "/api/document-sharable-link";

  static const String reminder = "/api/reminder";

  static const String fileRequest = "/api/file-request";
  static const String fileRequestDocument = "/api/file-request-document";
  static const String archivedRequest = "/api/archived-documents";
  static const String expiredRequest = "/api/expired-documents";
  static const String shareApi = "/api/documentUserPermission";
  static const String shareRoleListApi = "/api/DocumentRolePermission";
  static const String shareDocumentRolePermissionApi =
      "/api/documentRolePermission";
  static const String shareDocumentUserPermissionApi =
      "/api/documentUserPermission";

  static const String documentSignatureApi = "/api/document-signature";
  static const String startWorkFLowApi = "/api/workflow";
  static const String commentApi = "/api/documentComment";
  static const String documentApi = "/api/document";
  static const String operationApi = "/api/documentAuditTrail";
  static const String documentVersionApi = "/api/documentversion";
  static const String documentAuditsList = "/api/documentAuditTrail";
  static const String documentDetails = "/api/document";
  static const String workflowLogs = "/api/workflow-logs";
  static const String documentRemaindersList = "/api/reminder/all";

  static const String clientMaster = "/api/clients";
  static const String notificationsList = "/api/userNotification/notification";
  static const String recentDocuments = "/api/recent-documents";
  static const String sendEmail = "/api/email";
}
