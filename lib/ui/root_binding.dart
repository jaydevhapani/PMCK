import 'package:get/instance_manager.dart';
import 'package:pmck/ui/root_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RootControler>(RootControler());
  }
}
