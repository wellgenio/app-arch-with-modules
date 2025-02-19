import 'package:provider/single_child_widget.dart';

import '../modules/auth/auth_module.dart';
import '../modules/collection/collection_module.dart';
import '../modules/core/core_module.dart';
import '../modules/task/task_module.dart';

List<SingleChildWidget> get providers {
  return [
    ...coreModuleProviders,
    ...authModuleProviders,
    ...collectionModuleProviders,
    ...taskModuleProviders,
  ];
}
