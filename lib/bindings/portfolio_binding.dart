import 'package:get/get.dart';
import '../controllers/coin_controller.dart';
import '../controllers/portfolio_controller.dart';

class PortfolioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CoinController(), fenix: true);
    Get.lazyPut(() => PortfolioController(), fenix: true);
  }
}
