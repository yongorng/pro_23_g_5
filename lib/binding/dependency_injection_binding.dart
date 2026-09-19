import 'package:get/get.dart';

import '../services/api_client.dart';
import '../utils/token_storage.dart';

class DependencyInjectionBinding {
  const DependencyInjectionBinding._();

  static Future<void> init() async {
    final TokenStorage storage = await TokenStorage().init();

    Get.put<TokenStorage>(
      storage,
      permanent: true,
    );

    Get.put<ApiClient>(
      ApiClient(storage),
      permanent: true,
    );
  }
}
