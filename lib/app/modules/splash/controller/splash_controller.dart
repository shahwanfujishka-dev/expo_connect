import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/providers/api_service.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late final AnimationController animController;
  late final Animation<double> logoScale;
  late final Animation<double> logoFade;
  late final Animation<Offset> textSlide;
  late final Animation<double> textFade;

  @override
  void onInit() {
    super.onInit();

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );

    animController.forward();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 2200));

    // Session Persistence Logic
    final String? token = StorageService.getAuthToken();
    if (StorageService.isLoggedIn() && token != null) {
      // Set token in ApiService for authorized requests
      ApiService.instance.setToken(token);
      
      final userType = StorageService.getUserType();
      if (userType == 'exhibitor') {
        Get.offAllNamed(Routes.EXHIBITOR_MAIN);
      } else if (userType == 'visitor') {
        Get.offAllNamed(Routes.VISITOR_MAIN);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }
}
