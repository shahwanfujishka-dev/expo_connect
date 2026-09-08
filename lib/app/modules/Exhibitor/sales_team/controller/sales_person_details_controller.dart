import 'package:get/get.dart';
import '../../../../data/models/sales_team_model.dart';
import '../../../../data/repositories/sales_team_repository.dart';

class SalesPersonDetailsController extends GetxController {
  final SalesTeamRepository _repository = SalesTeamRepository();
  
  final RxBool isLoading = true.obs;
  final Rxn<SalesPerson> salesPerson = Rxn<SalesPerson>();
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as int?;
    if (id != null) {
      fetchDetails(id);
    } else {
      errorMessage.value = 'Invalid Sales Person ID';
      isLoading.value = false;
    }
  }

  Future<void> fetchDetails(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    final result = await _repository.getSalesPersonDetails(id);
    
    if (result.success && result.data != null) {
      salesPerson.value = result.data;
    } else {
      errorMessage.value = result.error?.message ?? 'Failed to load details';
    }
    
    isLoading.value = false;
  }
}
