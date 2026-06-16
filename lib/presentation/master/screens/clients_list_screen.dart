import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/presentation/master/controllers/master_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientsListScreen extends StatefulWidget {
  const ClientsListScreen({super.key});

  @override
  State<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  final controller = Get.find<MasterController>();
  final routerController = Get.find<RouterController>();

  @override
  void initState() {
    super.initState();
    controller.loadClients();
  }

  void routeToAddClientScreen() {
    routerController.router.push(AppScreens.addClientScreen);
  }

  void showClientDeleteDialog(
      BuildContext context,
      String clientId,
      String title,
      String body,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.error,
          ),
        ),
        content: Text(body, style: TextStyle(color: colorScheme.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("No", style: TextStyle(color: colorScheme.onSurface)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              controller.deleteClient(clientId, dialogContext);
            },
            child: Text(
              "Yes",
              style: TextStyle(color: colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Clients",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: routeToAddClientScreen,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      "Add",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.clients.isEmpty) {
          return const Center(child: Text("No Clients Found"));
        }

        return RefreshIndicator(
          color: Colors.red,
          onRefresh: () async {
            await controller.loadClients();
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(), // IMPORTANT
            itemCount: controller.clients.length,
            itemBuilder: (context, index) {
              final item = controller.clients[index];
              return _buildClientCard(item);
            },
          ),
        );
      }),
    );
  }

  Widget _buildClientCard(client) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              client.companyName ?? "",
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            _infoRow("Contact Person", client.contactPerson),
            _infoRow("Mobile", client.phoneNumber),
            _infoRow("Email", client.email),
            if ((client.address ?? "").isNotEmpty)
              _infoRow("Address", client.address),
            const SizedBox(height: 14),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.openEditClient(client),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text("Edit"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.secondary,
                      side: BorderSide(color: colorScheme.secondary),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => showClientDeleteDialog(
                      context,
                      client.id ?? "",
                      "Delete Client",
                      "Are you sure you want to delete this client?",
                    ),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text("Delete"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _infoRow(String label, String? value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              "$label:",
              style: theme.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "",
              style: theme.textTheme.bodySmall!.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}