import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import '../../../controllers/documents_controller.dart';

class DocumentSignatureScreen extends StatelessWidget {
  DocumentSignatureScreen({super.key});

  final DocumentsController controller = Get.find<DocumentsController>();

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityGained: (){
        controller.getDocumentSignatureList();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Document Signature',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.red,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => GoRouter.of(context).pop(),
            ),
          ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Signature(
                  controller: controller.signatureController,
                  height: 200,
                  backgroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: controller.clearSignature,
                        child: Text(
                            "Clear", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(width: 20),
                    Obx(() =>
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              controller.saveSignature(context);
                            },
                            child: controller.isLoading.value
                                ? Center(
                              child: CircularProgressIndicator(color: Colors
                                  .white),
                            )
                                : Text("Save", style: TextStyle(color: Colors
                                .white)),
                          ),
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 👇 SIGNATURE LIST VIEW
              Expanded(
                child: Obx(() {
                  if (controller.signatures.isEmpty) {
                    return Center(child: Text("No signatures added yet"));
                  }

                  return ListView.builder(
                    itemCount: controller.signatures.length,
                    itemBuilder: (context, i) {
                      final sig = controller.signatures[i];
                      final bytes =base64Decode(sig!.base64!);

                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Signature ${i + 1}",
                                  style: TextStyle(fontSize: 14,)),

                              SizedBox(height: 10),

                              Container(
                                width: double.infinity,
                                height: 150, // 🔥 Big size
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Image.memory(
                                  bytes,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text("Date : ${DateFormat('dd-MM-yyyy hh:mm a').format(sig.createdDate!)}",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                              /*Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => controller.deleteSignature(i),
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      );

                    },
                  );
                }),
              ),
            ],
          ),
      ),
    );
  }
}
