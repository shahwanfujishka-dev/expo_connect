import 'package:get/get.dart';

class FollowUpModel {
  final String exhibitorName;
  final String date;
  final String status;

  FollowUpModel({required this.exhibitorName, required this.date, required this.status});
}

class VisitorFollowUpController extends GetxController {
  final followUps = <FollowUpModel>[
    FollowUpModel(exhibitorName: "Nova Textiles", date: "Yesterday • 10:30 AM", status: "Pending"),
    FollowUpModel(exhibitorName: "Orbit Retail", date: "Yesterday • 2:15 PM", status: "Done"),
    FollowUpModel(exhibitorName: "Bluewave Inc", date: "2 days ago", status: "Pending"),
  ].obs;

  void scheduleMeeting(FollowUpModel item) {
    Get.snackbar("Schedule", "Opening calendar for ${item.exhibitorName}...");
  }

  void callExhibitor(FollowUpModel item) {
    Get.snackbar("Call", "Calling ${item.exhibitorName}...");
  }

  void sendEmail(FollowUpModel item) {
    Get.snackbar("Email", "Opening email draft for ${item.exhibitorName}...");
  }
}
