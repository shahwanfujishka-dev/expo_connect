import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../data/models/lead.dart';

class LeadDetailsController extends GetxController {
  late Lead lead;
  final notesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    lead = Get.arguments as Lead;
    notesController.text = "Mainly pricing for organic cotton, 500+ units. Sample kit requested.";
  }

  Future<void> callLead() async {
    if (lead.phone == null || lead.phone!.isEmpty) {
      Get.snackbar('Error', 'Phone number not available');
      return;
    }
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: lead.phone,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Get.snackbar('Error', 'Could not launch dialer');
    }
  }

  Future<void> whatsappLead() async {
    if (lead.phone == null || lead.phone!.isEmpty) {
      Get.snackbar('Error', 'Phone number not available');
      return;
    }
    
    // Format number: remove non-digits
    String cleanNumber = lead.phone!.replaceAll(RegExp(r'\D'), '');
    
    // WhatsApp URL scheme
    final Uri whatsappUri = Uri.parse("https://wa.me/$cleanNumber");
    
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'WhatsApp is not installed or could not be opened');
    }
  }

  Future<void> emailLead() async {
    if (lead.email == null || lead.email!.isEmpty) {
      Get.snackbar('Error', 'Email address not available');
      return;
    }
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: lead.email,
      query: 'subject=Expo Connect Follow-up',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar('Error', 'Could not launch email app');
    }
  }
}
