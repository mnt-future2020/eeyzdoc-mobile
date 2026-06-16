import 'package:dio/dio.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/services/api_client_service.dart';
import 'package:docuflow/data/models/request/client_request.dart';
import 'package:docuflow/data/models/response/client_response.dart';

abstract class MasterRemoteDatasource {
  Future<ClientResponse?> addClient(ClientRequest request);
  Future<List<ClientResponse?>?> getClientList();
  Future<ClientResponse?> editClient(String clientId, ClientRequest request);
  Future<void> deleteClient(String clientId);
}

class MasterRemoteDatasourceImpl implements MasterRemoteDatasource {
  final ApiClient dioClient;

  MasterRemoteDatasourceImpl(this.dioClient);

  @override
  Future<List<ClientResponse?>?> getClientList() async {

    try {
      final response = await dioClient.get(
        AppConstants.clientMaster,
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data.map((item) => ClientResponse.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("getClientList error: $e");
      return [];
    }
  }

  @override
  Future<ClientResponse?> addClient(ClientRequest request) async {

    try {
      final response = await dioClient.post(
        AppConstants.clientMaster,
        data: request.toJson(),
      );

      if (response.data != null) {
        return ClientResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("addClient error: $e");
      return null;
    }
  }

  @override
  Future<ClientResponse?> editClient(
    String clientId,
    ClientRequest request,
  ) async {

    try {
      final response = await dioClient.put(
        "${AppConstants.clientMaster}/$clientId",
        data: request.toJson(),
      );

      if (response.data != null) {
        return ClientResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("editClient error: $e");
      return null;
    }
  }

  @override
  Future<void> deleteClient(String clientId) async {

    try {
      await dioClient.delete(
        "${AppConstants.clientMaster}/$clientId",
      );
    } catch (e) {
      print("deleteClient error: $e");
    }
  }
}
