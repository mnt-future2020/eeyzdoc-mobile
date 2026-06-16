import 'package:docuflow/presentation/documents/controllers/document_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RemaindersDetailsScreen extends StatefulWidget {
  final String documentId;

  const RemaindersDetailsScreen({super.key, required this.documentId});

  @override
  State<RemaindersDetailsScreen> createState() =>
      _RemaindersDetailsScreenState();
}

class _RemaindersDetailsScreenState extends State<RemaindersDetailsScreen> {
  final controller = Get.find<DocumentDetailsController>();

  @override
  void initState() {
    super.initState();
    controller.loadReminders(); // <-- important
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingReminders.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.remindersList.isEmpty) {
        return const Center(
          child: Text("No Reminders Found", style: TextStyle(fontSize: 16)),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.remindersList.length,
        itemBuilder: (context, index) {
          final reminder = controller.remindersList[index];

          return Card(
            elevation: 4,
            shadowColor: Colors.red.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            margin: const EdgeInsets.only(bottom: 14),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.withOpacity(0.4), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE LINE WITH RED ACCENT
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            reminder.subject ?? "No Subject",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ALL ROWS
                    _row("Message", reminder.message),

                    if (reminder.startDate != null)
                      _row(
                        "Start Date",
                        DateFormat("dd-MM-yyyy hh:mm a").format(reminder.startDate!),
                      ),

                    if (reminder.endDate != null)
                      _row(
                        "End Date",
                        DateFormat("dd-MM-yyyy hh:mm a").format(reminder.endDate!),
                      ),

                    if (reminder.createdDate != null)
                      _row(
                        "Created",
                        DateFormat("dd-MM-yyyy hh:mm a").format(reminder.createdDate!),
                      ),
                  ],
                ),
              ),
            ),
          );

        },
      );
    });
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(
                color: Colors.black54,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
