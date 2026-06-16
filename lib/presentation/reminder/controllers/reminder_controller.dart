import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/reminder_details_response.dart';
import 'package:docuflow/data/models/response/reminder_response.dart';
import 'package:docuflow/data/models/response/user_dropdown_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/routes/router_controller.dart';
import '../../../core/utils/scaffold_message.dart';
import '../../../data/models/request/QuarterReminder.dart';
import '../../../domain/usecases/reminder_usecase.dart';
import 'package:go_router/go_router.dart';

import '../../documents/controllers/documents_controller.dart';
import '../../documents/dialog/dialog_widgets.dart'; // ADD THIS

class ReminderController extends GetxController {
  final ReminderUseCase reminderUseCase;

  RxList<ReminderResponse?> reminderResponseList = <ReminderResponse>[].obs;

  ReminderController({required this.reminderUseCase});

  RxBool isLoading = false.obs;
  RxString selectedFilter = 'Today'.obs;
  RxList<Map<String, String>> filteredReminders = <Map<String, String>>[].obs;
  final showUserDropdown = false.obs;
  final hasFocus = false.obs;
  final showAll = false.obs;
  var monthDays = <int>[].obs;
  var selectedDays = <int>[].obs;

  final routerController = Get.find<RouterController>();
  var reminders = <String, List<Map<String, String>>>{}.obs;
  final filters = ['Today', 'Tomorrow', 'This Week', 'This Month', 'Period'];

  final selectedDate = Rx<DateTime?>(null);
  var subject = "".obs;
  var message = "".obs;
  final TextEditingController subjectCtrl = TextEditingController();
  final TextEditingController messageCtrl = TextEditingController();

  var isRepeated = false.obs;
  var isEmailNotification = false.obs;
  var selectedWeekDays = <int>[].obs;

  var frequency = "-1".obs;
  var updatedReminderId = "".obs;
  var selectedFrequencyName = "".obs;
  var documentId = RxnString();
  var selectedWeekDay = 0.obs;

  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().add(Duration(hours: 1)).obs;
  final userSearchController = TextEditingController();
  final docController = Get.find<DocumentsController>();

  final RxList<UserDropdownResponse> selectedUsers =
      <UserDropdownResponse>[].obs;

  final RxList<UserDropdownResponse> usersList = <UserDropdownResponse>[].obs;

  List<Map<String, String>> frequencyList = [
    {"label": "None", "value": "-1"},
    {"label": "Daily", "value": "0"},
    {"label": "Weekly", "value": "1"},
    {"label": "Monthly", "value": "2"},
    {"label": "Quarterly", "value": "3"},
    {"label": "Half-Yearly", "value": "4"},
    {"label": "Yearly", "value": "5"},
  ];

  List<String> weekdays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  final weekDays = [
    {"id": 0, "label": "Mon"},
    {"id": 1, "label": "Tue"},
    {"id": 2, "label": "Wed"},
    {"id": 3, "label": "Thu"},
    {"id": 4, "label": "Fri"},
    {"id": 5, "label": "Sat"},
    {"id": 6, "label": "Sun"},
  ];
  var quarterlyReminders = <QuarterReminder>[].obs;

  int getTodayWeekdayId() {
    // Dart: Monday = 1, Sunday = 7
    // Your mapping: Sunday = 0, Monday = 1, … Saturday = 6
    int dartWeekday = DateTime.now().weekday; // 1–7
    if (dartWeekday == DateTime.sunday) return 0;
    return dartWeekday;
  }

  void initQuarterlyData() {
    final months = [
      "JANUARY",
      "FEBRUARY",
      "MARCH",
      "APRIL",
      "MAY",
      "JUNE",
      "JULY",
      "AUGUST",
      "SEPTEMBER",
      "OCTOBER",
      "NOVEMBER",
      "DECEMBER",
    ];

    quarterlyReminders.value = List.generate(4, (quarterIndex) {
      final monthValues = List.generate(3, (i) {
        final monthId = quarterIndex * 3 + i + 1;
        return MonthValue(id: monthId, name: months[monthId - 1]);
      });

      return QuarterReminder(
        quarter: quarterIndex,
        name:
            "${months[quarterIndex * 3].substring(0, 3)}_${months[quarterIndex * 3 + 2].substring(0, 3)}",
        monthValues: monthValues,
        month: monthValues.first.id,
        // <-- first month of quarter
        day: "10", // default day
      );
    });
  }

  void initHalfYearlyData() {
    final months = [
      "JANUARY",
      "FEBRUARY",
      "MARCH",
      "APRIL",
      "MAY",
      "JUNE",
      "JULY",
      "AUGUST",
      "SEPTEMBER",
      "OCTOBER",
      "NOVEMBER",
      "DECEMBER",
    ];

    quarterlyReminders.value = [
      QuarterReminder(
        quarter: 0,
        name: "JAN_JUN",
        monthValues: List.generate(
          6,
          (i) => MonthValue(id: i + 1, name: months[i]),
        ),
        month: 1,
        day: "10",
      ),
      QuarterReminder(
        quarter: 1,
        name: "JUL_DEC",
        monthValues: List.generate(
          6,
          (i) => MonthValue(id: i + 7, name: months[i + 6]),
        ),
        month: 7,
        day: "10",
      ),
    ];
  }

  @override
  void onInit() {
    super.onInit();
    applyFilter();
    getUsers();
    _initRemindersByFrequency(frequency.value);
    ever(frequency, (_) {
      _initRemindersByFrequency(frequency.value);
      applyFilter();
    });
    ever(selectedFilter, (_) {
      applyFilter();
    });
  }
  void setDocumentId(String? id) {
    documentId.value = id ?? "";
  }
  void _initRemindersByFrequency(String freq) {
    if (freq == "3") {
      initQuarterlyData();
    } else if (freq == "4") {
      initHalfYearlyData();
    } else {
      quarterlyReminders.clear();
    }
  }

  void loadReminderForEdit(ReminderDetailsResponse reminder) {
    Future.delayed(Duration.zero, () {
      updatedReminderId.value = reminder.id;

      subject.value = reminder.subject ?? '';
      message.value = reminder.message ?? '';
      frequency.value = reminder.frequency.toString();
      isRepeated.value = reminder.isRepeated == 1;
      isEmailNotification.value = reminder.isEmailNotification == 1;

      startDate.value = reminder.startDate!;
      endDate.value = reminder.endDate!;

      // ---- DAILY REMINDER FIX ----
      selectedWeekDays.assignAll(
        reminder.dailyReminders.map((d) => d.dayOfWeek),
      );

      for (var apiItem in reminder.quarterlyReminders) {
        int q = apiItem.quarter;
        if (q >= 0 && q < quarterlyReminders.length) {
          quarterlyReminders[q].day = apiItem.day;
          quarterlyReminders[q].month = apiItem.month;
        }
      }

      quarterlyReminders.refresh();

      selectedUsers.clear();
      for (var user in usersList) {
        if (reminder.reminderUsers.any((ru) => ru.userId == user.id)) {
          selectedUsers.add(user);
        }
      }
    });
  }

  void applyFilter() {
    final selected = selectedFilter.value;
    filteredReminders
      ..clear()
      ..addAll(reminders[selected] ?? []);
  }

  void goToAddPage(BuildContext context, String? reminderId) {
    routerController.router.push(
      AppScreens.remindersAddScreen,
      extra: {'reminderId': reminderId, 'documentId': null},
    );
  }

  Future<RxList<UserDropdownResponse>> getUsers() async {
    try {
      isLoading.value = true;

      final result = await docController.documentsUseCase.getUsers();

      if (result != null) {
        final nonNullUsers = result.whereType<UserDropdownResponse>();
        usersList.assignAll(nonNullUsers);
      } else {
        usersList.clear();
      }

      return usersList;
    } catch (e) {
      debugPrint("Error fetching users: $e");
      return usersList;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleDay(int day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }

  void selectAllDays() {
    selectedDays.value = List.generate(31, (index) => index + 1);
  }

  void unselectAllDays() {
    selectedDays.clear();
  }

  Future<void> getReminderList() async {
    isLoading.value = true;

    try {
      var reminderRequest = ReminderRequestQuery(
        fields: "",
        orderBy: "startDate desc",
        pageSize: 10,
        skip: 0,
        searchQuery: "",
        subject: "",
        message: "",
        frequency: "",
        documentId: "",
      );
      final response = await reminderUseCase.getReminderRequestApi(
        reminderRequest,
      );
      final safeList = (response ?? [])
          .where((e) => e != null)
          .cast<ReminderResponse>()
          .toList();

      reminderResponseList.value = safeList;

      reminderResponseList.value.forEach((action){
        print("ReminderResponse Date : ${action!.startDate} : ${action.endDate}");
      });


      if (reminderResponseList.value.isNotEmpty) {
        groupRemindersByDate();
      }
    } catch (e, st) {
      print("Reminder error: $e, StackTrace: $st");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getReminderDetails(String reminderId) async {
    // isLoading.value = true;

    try {
      ReminderDetailsResponse? response = await reminderUseCase
          .getReminderDetailsList(reminderId);
      loadReminderForEdit(response!);
    } catch (e, st) {
      print("Reminder error: $e, StackTrace: $st");
    } finally {
      // isLoading.value = false;
    }
  }

  void groupRemindersByDate() {
    reminders.value = {
      'Today': [],
      'Tomorrow': [],
      'This Week': [],
      'This Month': [],
      'Period': [],
    };

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(Duration(days: 1));

    // Current Week Range (Mon–Sun)
    DateTime weekStart = today.subtract(Duration(days: today.weekday - 1));
    DateTime weekEnd = weekStart.add(Duration(days: 6));

    // Current Month Range
    DateTime monthStart = DateTime(now.year, now.month, 1);
    DateTime monthEnd = DateTime(now.year, now.month + 1, 0);

    // Period Range: Today → +6 Months
    DateTime periodEnd = DateTime(now.year, now.month + 6, now.day);

    for (var reminder in reminderResponseList) {
      if (reminder?.startDate == null) continue;

      DateTime start = reminder!.startDate!;
      DateTime dateOnly = DateTime(start.year, start.month, start.day);

      String time = DateFormat('hh:mm a').format(start);
      String title = reminder.subject ?? "No Subject";
      var data = {"id": reminder.id, "title": title, "time": time};

      // Today
      if (dateOnly == today) {
        reminders['Today']!.add(data);
      }

      // Tomorrow
      if (dateOnly == tomorrow) {
        reminders['Tomorrow']!.add(data);
      }

      // This Week (Mon–Sun)
      if (dateOnly.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          dateOnly.isBefore(weekEnd.add(const Duration(days: 1)))) {
        reminders['This Week']!.add(data);
      }

      // This Month
      if (dateOnly.isAfter(monthStart.subtract(const Duration(days: 1))) &&
          dateOnly.isBefore(monthEnd.add(const Duration(days: 1)))) {
        reminders['This Month']!.add(data);
      }

      // Period (Future only — today → +6 months)
      if (dateOnly.isAfter(today.subtract(const Duration(days: 1))) &&
          dateOnly.isBefore(periodEnd.add(const Duration(days: 1)))) {
        reminders['Period']!.add(data);
      }
    }

    applyFilter(); // Refresh UI
  }

  void updateQuarterDay(int index, String newDay) {
    quarterlyReminders[index].day = newDay;
    quarterlyReminders.refresh(); // VERY IMPORTANT for GetX
  }

  void validateAndSave(BuildContext context) {

      if (subject.value.isEmpty) {
      ScaffoldMessageShow.show("Subject field are required" ?? '');
      return;
    }
    if (message.value.isEmpty) {
      ScaffoldMessageShow.show("Message fields are required" ?? '');
      return;
    }
    if (isRepeated.value && frequency.value == "-1") {
      ScaffoldMessageShow.show("Frequency fields are required" ?? '');
      return;
    }

   addReminder(context: context);
  }

  Future<void> addReminder({
    required BuildContext context,
    String? reminderId,
  }) async {
    try {
     // isLoading.value = true;
      final request = createReminderRequest();
      print("Request : $request");
      final response = await reminderUseCase.addReminderApi(request);

      if (response!.status == "Success") {
        ScaffoldMessageShow.show("${response.message}");
        await getReminderList();
        routerController.router.pop();
      } else {
        ScaffoldMessageShow.show("${response.message}");
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
      print("Error : ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> createReminderRequest() {
    return {
      "id": updatedReminderId.value,
      "subject": subjectCtrl.text.trim(),
      "message": messageCtrl.text.trim(),
      "frequency": frequency.value,
      // 0=daily,1=weekly,2=monthly,3=quarterly,4=half-yearly,5=yearly
      "isRepeated": isRepeated.value,
      "isEmailNotification": isEmailNotification.value,

      // Only include dates if repeated is true
      "startDate": startDate.value.toIso8601String(),
      "endDate": isRepeated.value
          ? endDate.value.toIso8601String()
          : null,

      // WEEKLY → single day
      "dayOfWeek":
          (frequency.value == "1" &&
              isRepeated.value &&
              selectedWeekDays.isNotEmpty)
          ? selectedWeekDays.first.toString()
          : null,

      "documentId": documentId.value,

      // MULTI-SELECT USERS
      "selectedUsers": selectedUsers
          .map(
            (u) => {
              "id": u.id,
              "firstName": u.firstName,
              "lastName": u.lastName,
              "userName": u.userName,
              "email": u.email,
            },
          )
          .toList(),

      // DAILY → multiple selected days
      "dailyReminders":
          (frequency.value == "0" &&
              isRepeated.value &&
              selectedWeekDays.isNotEmpty)
          ? selectedWeekDays
                .map(
                  (d) => {
                    "id": "",
                    "reminderId": "",
                    "dayOfWeek": d,
                    "isActive": true,
                    "name": weekDays[(d % 7)]["label"],
                  },
                )
                .toList()
          : [],

      // MONTHLY → list of selected days
      "monthlyDays":
          (frequency.value == "2" && isRepeated.value && monthDays.isNotEmpty)
          ? monthDays.map((d) => {"day": d.toString()}).toList()
          : [],

      // QUARTERLY / HALF-YEARLY → list of quarter reminders
      "quarterlyReminders":
          (frequency.value == "3" || frequency.value == "4") && isRepeated.value
          ? quarterlyReminders
                .map(
                  (q) => {
                    "id": "",
                    "reminderId": "",
                    "quarter": q.quarter,
                    "month": q.month,
                    "day": q.day,
                  },
                )
                .toList()
          : [],

      // REMINDER USERS LIST
      "reminderUsers": selectedUsers
          .map((u) => {"reminderId": "", "userId": u.id})
          .toList(),
    };
  }

  void selectUser(UserDropdownResponse user) {
    final isAlreadySelected = selectedUsers.any(
      (selectedUser) => selectedUser.id == user.id,
    );

    if (!isAlreadySelected) {
      selectedUsers.add(user);
    }
  }

  void removeUser(String userId) {
    selectedUsers.removeWhere((user) => user.id == userId);
  }

  bool isUserSelected(String userId) {
    return selectedUsers.any((user) => user.id == userId);
  }

  void deleteReminderConfirm(String reminderId)
  {
    deleteReminderConfirmation(reminderId,this);
  }



  Future<void> deleteReminder(String reminderId) async {
    try {

      final response = await reminderUseCase.deleteReminder(
        reminderId,
      );

      if (response!.status == "Success") {
        ScaffoldMessageShow.show(response.message ?? '');
        getReminderList();
      } else {
        ScaffoldMessageShow.show(response.message ?? '');
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
       // isLoading.value = false;
    }
  }
  void toggleUser(UserDropdownResponse user) {
    if (isUserSelected(user.id!)) {
      removeUser(user.id!);
    } else {
      selectUser(user);
    }
  }

  void clearUserSearch() {
    userSearchController.clear();
    showAll.value = false;
    if (hasFocus.value) showUserDropdown.value = true;
  }

  void clearForm() {
    subject.value = "";
    message.value = "";
    selectedDate.value = null;

    frequency.value = "-1";
    selectedFrequencyName.value = "";

    // Weekday selection
    selectedWeekDays.clear();
    selectedWeekDay.value = 0;

    // Boolean toggles
    isRepeated.value = false;
    isEmailNotification.value = false;

    // Quarterly/Half-Yearly reset
    quarterlyReminders.clear();

    // Users
    selectedUsers.clear();

    // Reset dates
    startDate.value = DateTime.now();
    endDate.value = DateTime.now().add(Duration(days: 1));
  }

  @override
  void onClose() {
    clearForm();
    documentId.value=null;
    subjectCtrl.dispose();
    messageCtrl.dispose();
    super.onClose();
  }
}
