import 'package:expo_connect/app/modules/Exhibitor/QrScan/QrScanScreen.dart';
import 'package:expo_connect/app/modules/Exhibitor/QrScan/binding/qrScan_binding.dart';
import 'package:expo_connect/app/modules/Exhibitor/business_card/BusinessCardScanScreen.dart';
import 'package:expo_connect/app/modules/Exhibitor/dashboard/Dashboard_Screen.dart';
import 'package:expo_connect/app/modules/Exhibitor/dashboard/binding/dashboard_binding.dart';
import 'package:expo_connect/app/modules/Exhibitor/exhibitor_profile/exhibitor_profile_screen.dart';
import 'package:expo_connect/app/modules/Exhibitor/exhibitor_profile/my_profile_screen.dart';
import 'package:expo_connect/app/modules/Exhibitor/exhibitor_profile/binding/my_profile_binding.dart';
import 'package:expo_connect/app/modules/Exhibitor/leads_save_screen/LeadSavedScreen.dart';
import 'package:expo_connect/app/modules/Exhibitor/leads_screen/lead_capture_screen/LeadCaptureScreen.dart';
import 'package:expo_connect/app/modules/Exhibitor/leads_screen/lead_capture_screen/binding/lead_capture_binding.dart';
import 'package:expo_connect/app/modules/Exhibitor/leads_screen/lead_details/binding/lead_details_binding.dart';
import 'package:expo_connect/app/modules/Exhibitor/leads_screen/lead_details/lead_details_screen.dart';
import 'package:expo_connect/app/modules/Exhibitor/manual_entry/ManualEntryScreen.dart';
import 'package:expo_connect/app/modules/Exhibitor/sales_team/binding/sales_person_details_binding.dart';
import 'package:expo_connect/app/modules/Exhibitor/sales_team/binding/sales_team_binding.dart';
import 'package:expo_connect/app/modules/Exhibitor/sales_team/view/sales_person_details_screen.dart';
import 'package:expo_connect/app/modules/Exhibitor/sales_team/view/sales_team_screen.dart';
import 'package:expo_connect/app/modules/Exhibitor/settings/binding/settings_binding.dart';
import 'package:expo_connect/app/modules/Exhibitor/settings/settings_screen.dart';
import 'package:expo_connect/app/modules/Visitor/discover/view/visitor_discover_screen.dart';
import 'package:expo_connect/app/modules/signUp/binding/signUp_binding.dart';
import 'package:expo_connect/app/modules/signUp/signUp_Screen.dart';
import 'package:get/get.dart';
import '../modules/Exhibitor/ExhibitorNav/ExhibitorMainScreen.dart';
import '../modules/Exhibitor/ExhibitorNav/ExhibitorNavBinding.dart';
import '../modules/Exhibitor/business_card/binding/business_card_binding.dart';
import '../modules/Exhibitor/events/binding/events_binding.dart';
import '../modules/Exhibitor/events/views/add_event_screen.dart';
import '../modules/Exhibitor/events/views/event_details_screen.dart';
import '../modules/Exhibitor/events/views/events_view.dart';
import '../modules/Exhibitor/exhibitor_profile/binding/exhibitor_profile_binding.dart';
import '../modules/Exhibitor/leads_save_screen/binding/leads_save_binding.dart';
import '../modules/Exhibitor/leads_screen/lead_pipeline/binding/lead_pipeline_binding.dart';
import '../modules/Exhibitor/leads_screen/lead_pipeline/lead_pipeline_screen.dart';
import '../modules/Exhibitor/manual_entry/binding/manual_entry_binding.dart';
import '../modules/Visitor/complete_profile/binding/visitor_complete_profile_binding.dart';
import '../modules/Visitor/complete_profile/view/visitor_complete_profile_screen.dart';
import '../modules/Visitor/discover/binding/visitor_discover_binding.dart';
import '../modules/Visitor/exhibitor_details/binding/exhibitor_details_binding.dart';
import '../modules/Visitor/exhibitor_details/view/exhibitor_details_screen.dart';
import '../modules/Visitor/profile/binding/visitor_profile_binding.dart';
import '../modules/Visitor/profile/view/visitor_profile_screen.dart';
import '../modules/Visitor/qr_scan/binding/visitor_qr_binding.dart';
import '../modules/Visitor/qr_scan/view/visitor_qr_scan_screen.dart';
import '../modules/Visitor/visitor_main/binding/visitor_main_binding.dart';
import '../modules/Visitor/visitor_main/view/visitor_main_screen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/binding/login_binding.dart';
import '../modules/login/login_page.dart';
import '../modules/otp/binding/otp_binding.dart';
import '../modules/otp/otp_screen.dart';
import '../modules/roleSelection/binding/role_binding.dart';
import '../modules/roleSelection/role_selection_screen.dart';
import '../modules/splash/binding/splash_binding.dart';
import '../modules/splash/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.OTP,
      page: () => const OtpScreen(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: Routes.ROLE_SELECTION,
      page: () => const RoleSelectionScreen(),
      binding: RoleBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignupScreen(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: Routes.EXHIBITOR_PROFILE,
      page: () => const ExhibitorProfileScreen(),
      binding: ExhibitorProfileBinding(),
    ),
    GetPage(
      name: Routes.VISITOR_PROFILE,
      page: () => const VisitorProfileScreen(),
      binding: VisitorProfileBinding(),
    ),
    GetPage(
      name: Routes.VISITOR_COMPLETE_PROFILE,
      page: () => const VisitorCompleteProfileScreen(),
      binding: VisitorCompleteProfileBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.LEAD_SAVED,
      page: () => const LeadSavedScreen(),
      binding: LeadsSaveBinding(),
    ),
    GetPage(
      name: Routes.LEAD_CAPTURE,
      page: () => const LeadCaptureScreen(),
      binding: LeadCaptureBinding(),
    ),
    GetPage(
      name: Routes.QR_SCAN,
      page: () => const QrScanScreen(),
      binding: QrscanBinding(),
    ),
    GetPage(
      name: Routes.BUSINESS_CARD_SCAN,
      page: () => const BusinessCardScanScreen(),
      binding: BusinessCardBinding(),
    ),
    GetPage(
      name: Routes.MANUAL_ENTRY,
      page: () => const ManualEntryScreen(),
      binding: ManualEntryBinding(),
    ),
    GetPage(
      name: Routes.EXHIBITOR_MAIN,
      page: () => const ExhibitorMainScreen(),
      binding: ExhibitorNavBinding(),
    ),
    GetPage(
      name: Routes.LEAD_PIPELINE,
      page: () => const LeadPipelineScreen(),
      binding: LeadPipelineBinding(),
    ),
    GetPage(
      name: Routes.LEAD_DETAILS,
      page: () => const LeadDetailsScreen(),
      binding: LeadDetailsBinding(),
    ),
    GetPage(
      name: Routes.MY_PROFILE,
      page: () => const MyProfileScreen(),
      binding: MyProfileBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.TEAM,
      page: () => const SalesTeamScreen(),
      binding: SalesTeamBinding(),
    ),
    GetPage(
      name: Routes.TEAM_DETAILS,
      page: () => const SalesPersonDetailsScreen(),
      binding: SalesPersonDetailsBinding(),
    ),
    GetPage(
      name: Routes.EXHIBITOR_EVENTS,
      page: () => const EventsView(),
      binding: EventsBinding(),
    ),
    GetPage(
      name: Routes.ADD_EVENT,
      page: () => const AddEventScreen(),
      binding: EventsBinding(),
    ),
    GetPage(
      name: Routes.EVENT_DETAILS,
      page: () => const EventDetailsScreen(),
      binding: EventsBinding(),
    ),

    // Visitor Pages
    GetPage(
      name: Routes.VISITOR_MAIN,
      page: () => const VisitorMainScreen(),
      binding: VisitorMainBinding(),
    ),
    GetPage(
      name: Routes.VISITOR_EXHIBITOR_DETAILS,
      page: () => const VisitorExhibitorDetailsScreen(),
      binding: VisitorExhibitorDetailsBinding(),
    ),
    GetPage(
      name: Routes.VISITOR_QR_SCAN,
      page: () => const VisitorQrScanScreen(),
      binding: VisitorQrBinding(),
    ),
    GetPage(
      name: Routes.VISITOR_DISCOVER,
      page: () => const VisitorDiscoverScreen(),
      binding: VisitorDiscoverBinding(),
    ),
  ];
}
