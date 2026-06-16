import 'package:docuflow/data/models/request/client_request.dart';
import 'package:docuflow/data/models/response/client_response.dart';

abstract class MasterRepository {
  Future<ClientResponse?> addClient(ClientRequest request);
  Future<List<ClientResponse?>?> getClientList();
  Future<ClientResponse?> editClient(String clientId, ClientRequest request);
  Future<void> deleteClient(String clientId);
}
