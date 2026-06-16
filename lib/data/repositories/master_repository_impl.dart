import 'package:docuflow/data/models/request/client_request.dart';
import 'package:docuflow/data/models/response/client_response.dart';
import 'package:docuflow/domain/repositories/master_repository.dart';
import 'package:docuflow/data/datasources/remote/master_remote_datasource.dart';

class MasterRepositoryImpl implements MasterRepository {
  final MasterRemoteDatasource remoteDatasource;

  MasterRepositoryImpl(this.remoteDatasource);

  @override
  Future<ClientResponse?> addClient(ClientRequest request) {
    return remoteDatasource.addClient(request);
  }

  @override
  Future<void> deleteClient(String clientId) {
    return remoteDatasource.deleteClient(clientId);
  }

  @override
  Future<ClientResponse?> editClient(String clientId, ClientRequest request) {
    return remoteDatasource.editClient(clientId, request);
  }

  @override
  Future<List<ClientResponse?>?> getClientList() {
    return remoteDatasource.getClientList();
  }
}
