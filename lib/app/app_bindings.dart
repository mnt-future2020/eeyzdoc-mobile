import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/data/datasources/remote/Documents_remote_datasource.dart';
import 'package:docuflow/data/datasources/remote/archived_remote_datasource.dart';
import 'package:docuflow/data/datasources/remote/auth_remote_datasource.dart';
import 'package:docuflow/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:docuflow/data/datasources/remote/document_details_datasource.dart';
import 'package:docuflow/data/datasources/remote/expired_remote_datasource.dart';
import 'package:docuflow/data/datasources/remote/file_request_remote_datasource.dart';
import 'package:docuflow/data/datasources/remote/reminder_remote_datasource.dart';
import 'package:docuflow/data/datasources/remote/work_flow_remote_datasource.dart';
import 'package:docuflow/data/repositories/auth_repository_impl.dart';
import 'package:docuflow/data/repositories/dashboard_repository_impl.dart';
import 'package:docuflow/data/repositories/document_details_repository_impl.dart';
import 'package:docuflow/data/repositories/documents_repository_impl.dart';
import 'package:docuflow/data/repositories/expired_repository_impl.dart';
import 'package:docuflow/data/repositories/workflow_repository_impl.dart';
import 'package:docuflow/domain/repositories/Documents_repository.dart';
import 'package:docuflow/domain/repositories/archived_repository.dart';
import 'package:docuflow/domain/repositories/auth_repository.dart';
import 'package:docuflow/domain/repositories/dashboard_repository.dart';
import 'package:docuflow/domain/repositories/document_details_repository.dart';
import 'package:docuflow/domain/repositories/expired_repository.dart';
import 'package:docuflow/domain/repositories/file_request_repository.dart';
import 'package:docuflow/domain/repositories/reminder_repository.dart';
import 'package:docuflow/domain/repositories/work_flow_repository.dart';
import 'package:docuflow/domain/usecases/document_details_usecase.dart';
import 'package:docuflow/domain/usecases/archived_usecase.dart';
import 'package:docuflow/domain/usecases/documents_usecase.dart';
import 'package:docuflow/domain/usecases/auth_usecase.dart';
import 'package:docuflow/domain/usecases/dashboard_usecase.dart';
import 'package:docuflow/domain/usecases/expired_usecase.dart';
import 'package:docuflow/domain/usecases/file_request_usecase.dart';
import 'package:docuflow/domain/usecases/reminder_usecase.dart';
import 'package:docuflow/core/services/api_client_service.dart';
import 'package:docuflow/core/themes/app_theme.dart';
import 'package:docuflow/domain/usecases/work_flow_usecase.dart';
import 'package:docuflow/presentation/main/controllers/dashboard_controller.dart';
import 'package:docuflow/presentation/user/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../data/datasources/remote/master_remote_datasource.dart';
import '../data/repositories/archived_repository_impl.dart';
import '../data/repositories/file_request_repository_impl.dart';
import '../data/repositories/master_repository_impl.dart';
import '../data/repositories/reminder_repository_impl.dart';
import '../domain/repositories/master_repository.dart';
import '../domain/usecases/master_usecase.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Theme controller
    Get.put(ThemeController(), permanent: true);

    // Router controller
    Get.put(RouterController(), permanent: true);
    // API Client (Global Singleton)
    Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);

    // AUTH MODULE
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<AuthUseCase>(
      () => AuthUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );


    // DASHBOARD MODULE
    Get.lazyPut<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(Get.find<DashboardRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<DashboardUseCase>(
      () => DashboardUseCase(Get.find<DashboardRepository>()),
      fenix: true,
    );

    // DOCUMENTS MODULE
    Get.lazyPut<DocumentsRemoteDataSource>(
      () => DocumentsRemoteDataSourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<DocumentsRepository>(
      () => DocumentsRepositoryImpl(Get.find<DocumentsRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<DocumentsUseCase>(
      () => DocumentsUseCase(Get.find<DocumentsRepository>()),
      fenix: true,
    );
    // DOCUMENT DETAILS MODULE
    Get.lazyPut<DocumentDetailsDatasource>(
      () => DocumentDetailsDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<DocumentDetailsRepository>(
      () =>
          DocumentDetailsRepositoryImpl(Get.find<DocumentDetailsDatasource>()),
      fenix: true,
    );
    Get.lazyPut<DocumentDetailsUseCase>(
      () => DocumentDetailsUseCase(Get.find<DocumentDetailsRepository>()),
      fenix: true,
    );
    // REMINDER MODULE
    Get.lazyPut<ReminderRemoteDatasource>(
      () => ReminderRemoteDataSourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<ReminderRepository>(
      () => ReminderRepositoryImpl(Get.find<ReminderRemoteDatasource>()),
      fenix: true,
    );
    Get.lazyPut<ReminderUseCase>(
      () => ReminderUseCase(Get.find<ReminderRepository>()),
      fenix: true,
    );
    // WORKFLOW MODULE
    Get.lazyPut<WorkFlowRemoteDatasource>(
      () => WorkFlowRemoteDataSourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<WorkFlowRepository>(
      () => WorkflowRepositoryImpl(Get.find<WorkFlowRemoteDatasource>()),
      fenix: true,
    );
    Get.lazyPut<WorkFlowUseCase>(
      () => WorkFlowUseCase(Get.find<WorkFlowRepository>()),
      fenix: true,
    );
    // FILE REQUEST MODULE
    Get.lazyPut<FileRequestRemoteDatasource>(
      () => FileRequestRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<FileRequestRepository>(
      () => FileRequestRepositoryImpl(Get.find<FileRequestRemoteDatasource>()),
      fenix: true,
    );
    Get.lazyPut<FileRequestUseCase>(
      () => FileRequestUseCase(Get.find<FileRequestRepository>()),
      fenix: true,
    );
    // ARCHIVED MODULE
    Get.lazyPut<ArchivedRemoteDatasource>(
      () => ArchivedRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<ArchivedRepository>(
      () => ArchivedRepositoryImpl(Get.find<ArchivedRemoteDatasource>()),
      fenix: true,
    );
    Get.lazyPut<ArchivedUseCase>(
      () => ArchivedUseCase(Get.find<ArchivedRepository>()),
      fenix: true,
    );
    // EXPIRED MODULE
    Get.lazyPut<ExpiredRemoteDatasource>(
      () => ExpiredRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<ExpiredRepository>(
      () => ExpiredRepositoryImpl(Get.find<ExpiredRemoteDatasource>()),
      fenix: true,
    );
    Get.lazyPut<ExpiredUseCase>(
      () => ExpiredUseCase(Get.find<ExpiredRepository>()),
      fenix: true,
    );

    // MASTER MODULE
    Get.lazyPut<MasterRemoteDatasource>(
          () => MasterRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<MasterRepository>(
          () => MasterRepositoryImpl(Get.find<MasterRemoteDatasource>()),
      fenix: true,
    );
    Get.lazyPut<MasterUseCase>(
          () => MasterUseCase(Get.find<MasterRepository>()),
      fenix: true,
    );
  }


}
