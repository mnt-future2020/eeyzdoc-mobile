import 'package:docuflow/data/models/request/client_request.dart';
import 'package:docuflow/data/models/response/client_response.dart';
import 'package:docuflow/domain/repositories/master_repository.dart';

class MasterUseCase {
  final MasterRepository repository;

  MasterUseCase(this.repository);

  Future<ClientResponse?> addClient(ClientRequest request) async {
    return repository.addClient(request);
  }

  Future<List<ClientResponse?>?> getClientList() async {
    return repository.getClientList();
  }

  Future<ClientResponse?> editClient(
    String clientId,
    ClientRequest request,
  ) async {
    return repository.editClient(clientId, request);
  }

  Future<void> deleteClient(String clientId) async {
    return repository.deleteClient(clientId);
  }
}
