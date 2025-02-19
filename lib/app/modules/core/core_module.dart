import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'adapters/http_client.dart';

export 'adapters/http_client.dart';

List<SingleChildWidget> get coreModuleProviders {
  return [
    Provider(create: (context) => HttpClientImpl.cached() as HttpClient),
  ];
}