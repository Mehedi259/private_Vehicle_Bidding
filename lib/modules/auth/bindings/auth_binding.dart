import 'package:get/get.dart';
import '../../../../core/interfaces/i_auth_repository.dart';
import '../../../../data/repositories/auth_repository_impl.dart';
import '../controllers/login_controller.dart';
import '../controllers/sign_up_controller.dart';
import '../controllers/verification_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAuthRepository>(() => AuthRepositoryImpl());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignUpController>(() => SignUpController());
    Get.lazyPut<VerificationController>(() => VerificationController(Get.find<IAuthRepository>()));
  }
}
