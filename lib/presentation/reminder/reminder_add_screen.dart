import 'package:docuflow/presentation/reminder/controllers/reminder_controller.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/models/response/user_dropdown_response.dart';
import '../../widgets/pickers/start_end_date_picker.dart';
import '../documents/controllers/documents_controller.dart';

class ReminderAddScreen extends StatelessWidget {
  final String? editingReminderId;
  final String? documentId;

  ReminderAddScreen({super.key, this.editingReminderId, this.documentId});

  @override
  Widget build(BuildContext context) {
    final ReminderController controller = Get.find<ReminderController>();
    controller.setDocumentId(documentId);
    if (editingReminderId != null) {
      controller.getReminderDetails(editingReminderId!);
    } else {
      controller.clearForm();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editingReminderId == null ? 'Add Reminder' : 'Edit Reminder',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textField("Subject", controller.subject, controller.subjectCtrl),
            SizedBox(height: 16),

            _textArea("Message", controller.message, controller.messageCtrl),
            SizedBox(height: 16),

            Obx(
                  () =>
                  Row(
                    children: [
                      Checkbox(
                        value: controller.isRepeated.value,
                        onChanged: (v) => controller.isRepeated.value = v!,
                      ),
                      Text("Repeat Reminder"),

                      SizedBox(width: 20),

                      Checkbox(
                        value: controller.isEmailNotification.value,
                        onChanged: (v) =>
                        controller.isEmailNotification.value = v!,
                      ),
                      Text("Send Email"),
                    ],
                  ),
            ),

            Obx(() {
              if (!controller.isRepeated.value) return SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),

                  _frequencyDropdown(controller),

                  if (controller.frequency.value == "0" ||
                      controller.frequency.value == "1")
                    _weekDaySelector(controller),
                  if (controller.frequency.value == "2")
                    monthlySelect(controller),
                  quarterlySection(controller),
                ],
              );
            }),
            _buildAssignWithUsersSection(context, controller),
            Row(
              children: [
                startEndDatePicker("Reminder Start Date", controller.startDate),
                Spacer(),
                Obx(
                      () =>
                  controller.isRepeated.value
                      ? startEndDatePicker(
                    "Reminder End Date",
                    controller.endDate,
                    startDateObs: controller.startDate,
                  )
                      : SizedBox.shrink(),
                ),
              ],
            ),

            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Obx(() {
                  return Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.validateAndSave(context),
                      child: Text(
                        editingReminderId == null ? 'Save Reminder' : 'Update',
                        style: const TextStyle(color: Colors.white,
                            fontSize: 14),
                      ),
                    ),
                  );
                }),
                SizedBox(width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(String label, RxString obs, TextEditingController ctrl) {
    return Obx(() {
      if (ctrl.text != obs.value) {
        ctrl.text = obs.value; // <-- update UI when editing
        ctrl.selection = TextSelection.fromPosition(
          TextPosition(offset: ctrl.text.length),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 6),
          TextField(
            controller: ctrl,
            onChanged: (v) => obs.value = v,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: label,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAssignWithUsersSection(BuildContext context,
      ReminderController controller,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
              () =>
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.selectedUsers.map((user) {
                  return Chip(
                    label: Text(user.userName ?? ''),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => controller.selectedUsers.remove(user),
                    backgroundColor: Colors.red.withOpacity(0.1),
                    labelStyle: const TextStyle(color: Colors.red),
                  );
                }).toList(),
              ),
        ),
        const SizedBox(height: 12),

        _buildSearchableUsersDropdown(controller),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSearchableUsersDropdown(ReminderController controller) {
    return Obx(() {
      final query = controller.userSearchController.text.toLowerCase();
      final filteredUsers = controller.usersList.where((user) {
        final matchesQuery = user.userName!.toLowerCase().contains(query);
        final notSelected = !controller.isUserSelected(user.id!);
        return matchesQuery && notSelected;
      }).toList();

      List<UserDropdownResponse> rolesToShow = [];
      if (controller.showUserDropdown.value && filteredUsers.isNotEmpty) {
        rolesToShow = (query.isEmpty && !controller.showAll.value)
            ? filteredUsers.take(5).toList()
            : filteredUsers;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Focus(
            onFocusChange: (focus) {
              controller.hasFocus.value = focus;
              if (focus) {
                controller.showUserDropdown.value = true;
                controller.showAll.value = false;
              } else {
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (!controller.hasFocus.value) {
                    controller.showUserDropdown.value = false;
                  }
                });
              }
            },
            child: TextField(
              controller: controller.userSearchController,
              decoration: InputDecoration(
                hintText: 'Search Users...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clearUserSearch,
                )
                    : null,
              ),
              onChanged: (_) {
                controller.showUserDropdown.value = true;
                if (query.isNotEmpty) controller.showAll.value = true;
              },
              onTap: () => controller.showUserDropdown.value = true,
            ),
          ),

          if (controller.showUserDropdown.value && filteredUsers.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              constraints: BoxConstraints(
                maxHeight: rolesToShow.length > 5 ? 220 : 150,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: rolesToShow.length,
                      itemBuilder: (context, index) {
                        final role = rolesToShow[index];
                        return ListTile(
                          title: Text(role.userName ?? ''),
                          onTap: () {
                            controller.selectUser(role);
                            controller.clearUserSearch();
                            controller.showUserDropdown.value = false;
                            controller.hasFocus.value = false;
                          },
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                        );
                      },
                    ),
                  ),

                  if (query.isEmpty &&
                      filteredUsers.length > 5 &&
                      !controller.showAll.value)
                    TextButton(
                      onPressed: () => controller.showAll.value = true,
                      child: Text(
                        'Show All (${filteredUsers.length - 5} more)',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),

          if (controller.showUserDropdown.value && filteredUsers.isEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'No Users available or already selected',
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      );
    });
  }

  Widget _textArea(String label, RxString obs, TextEditingController ctrl) {
    return Obx(() {
      // Sync UI with Rx value (for editing)
      if (ctrl.text != obs.value) {
        ctrl.text = obs.value;
        ctrl.selection = TextSelection.fromPosition(
          TextPosition(offset: ctrl.text.length),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 6),
          TextField(
            controller: ctrl,
            maxLines: 4,
            style: const TextStyle(color: Colors.black),
            // Text color
            onChanged: (v) => obs.value = v,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: label,
            ),
          ),
        ],
      );
    });
  }

  Widget _frequencyDropdown(ReminderController controller) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Frequency"),
          SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: controller.frequency.value == "-1"
                ? null
                : controller.frequency.value,
            hint: Text("Select Frequency"),
            // 👈 ADDED
            decoration: InputDecoration(border: OutlineInputBorder()),
            items: controller.frequencyList.map((e) {
              return DropdownMenuItem<String>(
                value: e["value"],
                child: Text(e["label"].toString()),
              );
            }).toList(),
            onChanged: (v) {
              controller.frequency.value = v!;

              final selected = controller.frequencyList.firstWhere(
                    (item) => item["value"] == v,
              );

              controller.selectedFrequencyName.value = selected["label"]
                  .toString();

              if (v == "0") {
                controller.selectedWeekDays.value = controller.weekDays
                    .map((d) => d["id"] as int)
                    .toList();
              } else if (v == "1") {
                // Weekly — default to today
                final todayId = controller.getTodayWeekdayId();
                controller.selectedWeekDays.value = [todayId];
              }
              else {
                controller.selectedWeekDays.clear();
              }
            },
          ),
          SizedBox(height: 16),
          Text(
            controller.selectedFrequencyName.value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      );
    });
  }

  Widget monthlySelect(ReminderController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              onPressed: controller.selectAllDays,
              icon: const Icon(Icons.done_all),
              label: const Text("Select All"),
            ),

            const SizedBox(width: 12),

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              onPressed: controller.unselectAllDays,
              icon: const Icon(Icons.clear),
              label: const Text("Clear All"),
            ),
          ],
        ),

        Obx(() {
          return Wrap(
            spacing: 8,
            children: List.generate(31, (index) {
              final day = index + 1;
              final isSelected = controller.selectedDays.contains(day);

              return ChoiceChip(
                label: Text(day.toString()),
                selected: isSelected,
                onSelected: (_) => controller.toggleDay(day),
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey[300],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _weekDaySelector(ReminderController controller) {
    return Obx(() {
      if (controller.frequency.value != "0" &&
          controller.frequency.value != "1") {
        return SizedBox.shrink();
      }

      return Wrap(
        spacing: 8,
        children: controller.weekDays.map((day) {
          final int id = day["id"] as int;
          final bool isSelected = controller.selectedWeekDays.contains(id);

          return ChoiceChip(
            showCheckmark: false,
            selected: isSelected,

            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Icon(Icons.check, size: 18, color: Colors.white),
                  SizedBox(width: 4),
                ],
                Text(
                  day["label"].toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            selectedColor: Colors.red,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),

            onSelected: (selected) {
              if (controller.frequency.value == "0") {
                if (selected) {
                  controller.selectedWeekDays.add(id);
                } else {
                  controller.selectedWeekDays.remove(id);
                }
              } else if (controller.frequency.value == "1") {
                controller.selectedWeekDays
                  ..clear()
                  ..add(id);
              }
            },
          );
        }).toList(),
      );
    });
  }

  Widget quarterlySection(ReminderController controller) {
    return Obx(() {
      if (controller.frequency.value != "3" &&
          controller.frequency.value != "4")
        return SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...controller.quarterlyReminders.map((q) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  q.name.replaceAll("_", "  "),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        key: ValueKey(q.quarter),
                        value: q.month,
                        items: q.monthValues
                            .map(
                              (m) =>
                              DropdownMenuItem(
                                value: m.id,
                                child: Text(m.name),
                              ),
                        )
                            .toList(),
                        onChanged: (v) {
                          q.month = v!;
                          controller.quarterlyReminders.refresh();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        hint: Text("Select Month"),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Day Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: q.day,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(31, (i) {
                          final d = (i + 1).toString();
                          return DropdownMenuItem(value: d, child: Text(d));
                        }),
                        onChanged: (v) {
                          q.day = v!;
                          controller.quarterlyReminders.refresh();
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
              ],
            );
          }).toList(),
        ],
      );
    });
  }

}
