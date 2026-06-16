import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncrementDecrementField extends StatelessWidget {
  final DocumentsController controller = Get.find<DocumentsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final textController = TextEditingController(
        text: controller.selectedRetentionPeriod.value.toString(),
      );

      textController.selection = TextSelection.collapsed(
        offset: textController.text.length,
      );

      return SizedBox(
        width: double.infinity,
        child: TextField(
          controller: textController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Retention Period ',
            prefixIcon: IconButton(
              icon: const Icon(Icons.remove,color: Colors.redAccent,),
              onPressed: controller.decrement,
            ),

            // ➕ Increment icon
            suffixIcon: IconButton(
              icon: const Icon(Icons.add,color: Colors.redAccent,),
              onPressed: controller.increment,
            ),

            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
      );
    });
  }
}
